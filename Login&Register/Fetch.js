// Configuration
const API_BASE_URL = 'http://localhost:3000';

// Utility function to show loading states
function setLoadingState(button, isLoading, originalText = 'Submit') {
  if (isLoading) {
    button.disabled = true;
    button.innerHTML = '<span>Loading...</span>';
  } else {
    button.disabled = false;
    button.innerHTML = originalText;
  }
}

// Utility function to show alerts/notifications
function showNotification(message, type = 'info') {
  // You can customize this to use a better notification system
  if (type === 'error') {
    alert('Error: ' + message);
  } else if (type === 'success') {
    alert('Success: ' + message);
  } else {
    alert(message);
  }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  initializeEventListeners();
  updateCartCount();
  displayUsername();
  checkAuthStatus();
});

function initializeEventListeners() {
  // Registration form
  const registrationForm = document.getElementById('registration-form');
  if (registrationForm) {
    registrationForm.addEventListener('submit', handleRegistration);
  }

  // Login form
  const loginForm = document.getElementById('login-form');
  if (loginForm) {
    loginForm.addEventListener('submit', handleLogin);
  }

  // Logout button
  const logoutBtn = document.getElementById("logoutBtn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", handleLogout);
  }
}

async function handleRegistration(event) {
  event.preventDefault();

  const form = event.target;
  const submitBtn = document.getElementById('submit-button');
  const originalText = submitBtn.textContent;
  
  setLoadingState(submitBtn, true, originalText);

  try {
    // Get form data
    const formData = {
      name: form.name.value.trim(),
      surname: form.surname.value.trim(),
      email: form.email.value.trim(),
      password: form.password.value.trim(),
      confirm_password: form.confirm_password?.value.trim(),
      // Optional fields
      age: form.age?.value.trim() || null,
      gender: form.gender?.value || null,
      phone: form.phone?.value.trim() || null,
      country: form.country?.value.trim() || null,
      marital_status: form.marital_status?.value || null,
      next_of_kin: form.next_of_kin?.value.trim() || null
    };

    // Client-side validation
    const validationError = validateRegistrationData(formData);
    if (validationError) {
      showNotification(validationError, 'error');
      return;
    }

    // Make API call
    const response = await fetch(`${API_BASE_URL}/register`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'include',
      body: JSON.stringify(formData)
    });

    const result = await response.json();

    if (response.ok) {
      // Success
      showNotification(result.message || 'Registration successful!', 'success');
      form.reset();
      
      // Show success modal if it exists
      const successModal = document.getElementById('success-modal');
      if (successModal) {
        successModal.style.display = 'flex';
      }

      // Redirect after delay
      setTimeout(() => {
        window.location.href = '/Home-Page/index.html';
      }, 2000);
    } else {
      // Error from server
      showNotification(result.message || 'Registration failed', 'error');
    }

  } catch (error) {
    console.error('Registration error:', error);
    showNotification('Registration failed due to network error. Please try again.', 'error');
  } finally {
    setLoadingState(submitBtn, false, originalText);
  }
}

function validateRegistrationData(data) {
  if (!data.name || !data.surname || !data.email || !data.password) {
    return "Please fill out all required fields.";
  }

  if (data.password.length < 6) {
    return "Password must be at least 6 characters long.";
  }

  if (data.confirm_password && data.password !== data.confirm_password) {
    return 'Passwords do not match.';
  }

  // Basic email validation
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(data.email)) {
    return 'Please enter a valid email address.';
  }

  return null; // No validation errors
}

async function handleLogin(event) {
  event.preventDefault();

  const form = event.target;
  const email = form.email?.value.trim() || document.querySelector('#email')?.value.trim();
  const password = form.password?.value.trim() || document.querySelector('#password')?.value.trim();

  if (!email || !password) {
    showNotification('Please enter both email and password.', 'error');
    return;
  }

  const submitBtn = form.querySelector('button[type="submit"]') || document.querySelector('#login-button');
  const originalText = submitBtn?.textContent || 'Login';
  
  if (submitBtn) {
    setLoadingState(submitBtn, true, originalText);
  }

  try {
    const response = await fetch(`${API_BASE_URL}/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'include',
      body: JSON.stringify({ email, password })
    });

    const data = await response.json();

    if (response.ok && data.message === 'Login successful') {
      // Store user data in localStorage for quick access
      if (data.user && data.user.profile) {
        localStorage.setItem('loggedInUserName', data.user.profile.name || '');
        localStorage.setItem('loggedInUserSurname', data.user.profile.surname || '');
        localStorage.setItem('loggedInUserEmail', data.user.profile.email || '');
      }

      showNotification('Login successful! Redirecting...', 'success');
      
      // Show success modal if it exists
      const successModal = document.getElementById("success-modal");
      if (successModal) {
        successModal.style.display = "flex";
      }

      // Redirect after delay
      setTimeout(() => {
        window.location.href = '/Home-Page/index.html';
      }, 2000);
    } else {
      showNotification(data.message || 'Invalid login credentials.', 'error');
    }

  } catch (error) {
    console.error('Login error:', error);
    showNotification('Login failed due to network error. Please try again.', 'error');
  } finally {
    if (submitBtn) {
      setLoadingState(submitBtn, false, originalText);
    }
  }
}

async function handleLogout() {
  try {
    // Clear localStorage
    localStorage.removeItem('loggedInUserName');
    localStorage.removeItem('loggedInUserSurname');
    localStorage.removeItem('loggedInUserEmail');

    // Clear all cookies
    document.cookie.split(";").forEach(function (c) {
      document.cookie = c.trim().split("=")[0] + "=;expires=Thu, 01 Jan 1970 00:00:00 UTC;path=/;";
    });

    // Call logout endpoint
    const response = await fetch(`${API_BASE_URL}/logout`, { 
      method: "POST",
      credentials: 'include'
    });

    if (response.ok) {
      showNotification('Logged out successfully', 'success');
    }

    // Redirect regardless of API response
    setTimeout(() => {
      window.location.href = "../Home-Page/index.html";
    }, 1000);

  } catch (error) {
    console.error('Logout error:', error);
    // Still redirect even if API call fails
    window.location.href = "../Home-Page/index.html";
  }
}

async function displayUsername() {
  const usernameDisplay = document.getElementById('usernameDisplay');
  if (!usernameDisplay) return;

  try {
    // Try to get user profile from server
    const response = await fetch(`${API_BASE_URL}/user/profile`, {
      method: 'GET',
      credentials: 'include'
    });

    if (response.ok) {
      const data = await response.json();
      const fullName = data.surname ? `${data.name} ${data.surname}` : data.name;
      usernameDisplay.textContent = fullName;
      
      // Update localStorage with fresh data
      localStorage.setItem('loggedInUserName', data.name || '');
      localStorage.setItem('loggedInUserSurname', data.surname || '');
      localStorage.setItem('loggedInUserEmail', data.email || '');
    } else {
      throw new Error('Not authenticated');
    }
  } catch (error) {
    // Fallback to localStorage
    const name = localStorage.getItem('loggedInUserName');
    const surname = localStorage.getItem('loggedInUserSurname');
    
    if (name) {
      usernameDisplay.textContent = surname ? `${name} ${surname}` : name;
    } else {
      usernameDisplay.textContent = 'Guest';
    }
  }
}

async function checkAuthStatus() {
  try {
    const response = await fetch(`${API_BASE_URL}/user/profile`, {
      method: 'GET',
      credentials: 'include'
    });

    const isAuthenticated = response.ok;
    
    // Update UI based on authentication status
    updateUIForAuthStatus(isAuthenticated);
    
    return isAuthenticated;
  } catch (error) {
    console.error('Auth check error:', error);
    updateUIForAuthStatus(false);
    return false;
  }
}

function updateUIForAuthStatus(isAuthenticated) {
  // Show/hide elements based on auth status
  const authElements = document.querySelectorAll('[data-auth="required"]');
  const guestElements = document.querySelectorAll('[data-auth="guest"]');
  
  authElements.forEach(el => {
    el.style.display = isAuthenticated ? '' : 'none';
  });
  
  guestElements.forEach(el => {
    el.style.display = isAuthenticated ? 'none' : '';
  });
}

function updateCartCount() {
  try {
    const cart = JSON.parse(localStorage.getItem('cart')) || [];
    const count = cart.reduce((acc, item) => acc + (item.quantity || 0), 0);
    
    // Update cart count in various possible locations
    const cartCountSelectors = [
      'a[aria-label="Shopping Cart"] span',
      '.cart-count',
      '#cart-count',
      '[data-cart-count]'
    ];
    
    cartCountSelectors.forEach(selector => {
      const element = document.querySelector(selector);
      if (element) {
        element.textContent = count;
      }
    });
  } catch (error) {
    console.error('Error updating cart count:', error);
  }
}

// Profile update function
async function updateProfile(profileData) {
  try {
    const response = await fetch(`${API_BASE_URL}/user/profile/update`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'include',
      body: JSON.stringify(profileData)
    });

    const result = await response.json();

    if (response.ok) {
      showNotification(result.message || 'Profile updated successfully!', 'success');
      // Refresh displayed username
      displayUsername();
      return true;
    } else {
      showNotification(result.message || 'Profile update failed', 'error');
      return false;
    }
  } catch (error) {
    console.error('Profile update error:', error);
    showNotification('Profile update failed due to network error.', 'error');
    return false;
  }
}

// Email receipt function
async function sendReceipt(email, cart) {
  try {
    const response = await fetch(`${API_BASE_URL}/send-receipt`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'include',
      body: JSON.stringify({ email, cart })
    });

    const result = await response.json();

    if (response.ok) {
      showNotification('Receipt sent successfully!', 'success');
      return true;
    } else {
      showNotification(result.error || 'Failed to send receipt', 'error');
      return false;
    }
  } catch (error) {
    console.error('Receipt send error:', error);
    showNotification('Failed to send receipt due to network error.', 'error');
    return false;
  }
}

// Utility function to get current user data
async function getCurrentUser() {
  try {
    const response = await fetch(`${API_BASE_URL}/user/profile`, {
      method: 'GET',
      credentials: 'include'
    });

    if (response.ok) {
      return await response.json();
    }
    return null;
  } catch (error) {
    console.error('Get current user error:', error);
    return null;
  }
}

// Export functions for use in other scripts
window.AuthAPI = {
  handleRegistration,
  handleLogin,
  handleLogout,
  displayUsername,
  checkAuthStatus,
  updateProfile,
  sendReceipt,
  getCurrentUser,
  updateCartCount
};