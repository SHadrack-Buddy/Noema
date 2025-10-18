$htmlFiles = Get-ChildItem -Path "c:\Users\Shadrack\Desktop\Tourism Website 4.0" -Filter "*.html" -Recurse

$header = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tourism Website</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="../css/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        body {
            font-family: 'Poppins', sans-serif;
        }
    </style>
</head>
<body class="bg-white flex flex-col min-h-screen">
    <header class="bg-black text-white shadow-md">
        <div class="container mx-auto px-4 py-3 flex items-center justify-between">
            <div class="flex items-center">
                <img src="../Logo1.png" alt="Tourism Logo" class="h-10 w-auto">
            </div>
            <nav class="hidden md:flex space-x-8">
                <a href="../Home-Page/index.html" class="relative hover:text-gray-300 transition duration-300 transform hover:scale-105 after:content-[''] after:absolute after:left-0 after:bottom-[-4px] after:w-0 after:h-[2px] after:bg-white after:transition-all after:duration-300 hover:after:w-full">Home</a>
                <a href="../Book/Book.html" class="relative hover:text-gray-300 transition duration-300 transform hover:scale-105 after:content-[''] after:absolute after:left-0 after:bottom-[-4px] after:w-0 after:h-[2px] after:bg-white after:transition-all after:duration-300 hover:after:w-full">Book</a>
                <a href="../Events/Events.html" class="relative hover:text-gray-300 transition duration-300 transform hover:scale-105 after:content-[''] after:absolute after:left-0 after:bottom-[-4px] after:w-0 after:h-[2px] after:bg-white after:transition-all after:duration-300 hover:after:w-full">Events</a>
                <a href="../Current-Affairs/news.html" class="relative hover:text-gray-300 transition duration-300 transform hover:scale-105 after:content-[''] after:absolute after:left-0 after:bottom-[-4px] after:w-0 after:h-[2px] after:bg-white after:transition-all after:duration-300 hover:after:w-full">News</a>
                <a href="../About-Us/About.html" class="relative hover:text-gray-300 transition duration-300 transform hover:scale-105 after:content-[''] after:absolute after:left-0 after:bottom-[-4px] after:w-0 after:h-[2px] after:bg-white after:transition-all after:duration-300 hover:after:w-full">About</a>
                <a href="../Resources/Resources.html" class="relative hover:text-gray-300 transition duration-300 transform hover:scale-105 after:content-[''] after:absolute after:left-0 after:bottom-[-4px] after:w-0 after:h-[2px] after:bg-white after:transition-all after:duration-300 hover:after:w-full">Resources</a>
                <a href="../Marketplace/Marketplace.html" class="relative hover:text-gray-300 transition duration-300 transform hover:scale-105 after:content-[''] after:absolute after:left-0 after:bottom-[-4px] after:w-0 after:h-[2px] after:bg-white after:transition-all after:duration-300 hover:after:w-full">Marketplace</a>
            </nav>
            <div class="flex items-center space-x-4">
                <!-- Search -->
              <div class="relative">
                <input 
                  type="text" 
                  placeholder="Search news..." 
                  class="bg-white text-gray-900 px-4 py-2 rounded-full w-64 focus:outline-none focus:ring-2 focus:ring-gray-400">
                <button class="absolute right-3 top-2.5 text-gray-500 hover:text-black transition-transform duration-300 hover:translate-x-1 hover:scale-110">
                  <i class="fas fa-search"></i>
                </button>
              </div>
            
              <!-- Account Dropdown -->
              <div class="relative group">
                <button class="bg-white text-black px-4 py-2 rounded-md hover:bg-gray-100 transition flex items-center space-x-2">
                  <i class="fas fa-user"></i>
                  <span>Account</span>
                  <i class="fas fa-chevron-down text-sm transition-transform duration-300 group-hover:rotate-180"></i>
                </button>
                <div class="absolute right-0 mt-2 w-48 bg-white/90 backdrop-blur-xl shadow-lg rounded-lg border border-gray-300 opacity-0 invisible transform scale-95 -translate-y-4 transition-all duration-500 ease-out group-hover:opacity-100 group-hover:visible group-hover:scale-100 group-hover:translate-y-0">
                  <a href="/Login&Register/Login.html" class="block px-5 py-3 text-gray-700 font-medium transition-all duration-300 rounded-t-lg hover:bg-black hover:text-white hover:shadow-md hover:scale-105">Login</a>
                  <a href="/Login&Register/Register.html" class="block px-5 py-3 text-gray-700 font-medium transition-all duration-300 rounded-b-lg hover:bg-black hover:text-white hover:shadow-md hover:scale-105">Register</a>
                </div>
              </div>
            </div>
        </div>
    </header>
"@

$footer = @"
    <!-- FOOTER LOGO -->
    <div class="footer-logo">
        <div class="container">
            <img src="../Photos/NoemaLogo.jpg" alt="Company Logo">
        </div>
    </div>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="footer-col">
                    <h4>Support</h4>
                    <ul>
                        <li><a href="../About-Us/About.html">about us</a></li>
                        <li><a href="../Resources/Resources.html">our services</a></li>
                        <li><a href="#">privacy policy</a></li>
                        <li><a href="#">Terms and Conditions</a></li>
                        <li><a href="../Login&Register/Login.html">Login</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Explore</h4>
                    <ul>
                        <li><a href="../Marketplace/Marketplace.html">Marketplace</a></li>
                        <li><a href="../Current-Affairs/news.html">News</a></li>
                        <li><a href="../Book/Book.html">Booking</a></li>
                        <li><a href="../Events/Events.html">Events</a></li>
                        <li><a href="../Cart/cart.html">Shopping Cart</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Location</h4>
                    <address class="location">
                        <p><strong>Noema Tourism Services</strong></p>
                        <p>EastLondon Block 9, Plot 20994</p>
                        <p><a href="mailto:marketing@noemaservices.co.bw">marketing@noemaservices.co.bw</a></p>
                        <p><a href="tel:+2739133922">Tel: +27 391 33922</a> | <a href="tel:+273947978">Fax: +27 394 7978</a></p>
                    </address>
                </div>
                <div class="footer-col">
                    <h4>follow us</h4>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-tiktok"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <div class="copyright">
        <p>&copy; 2025 Noema Tourism Services Inc. All rights reserved.</p>
    </div>
</body>
</html>
"@

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Get the main content between header and footer
    $mainContent = $content -replace '(?s)^.*?<body.*?>', '' -replace '(?s)<footer.*$', ''
    
    # Calculate relative path to root
    $relativePath = '..' + $file.DirectoryName.Replace('c:\Users\Shadrack\Desktop\Tourism Website 4.0', '').Replace('\', '/') + '/'
    
    # Adjust paths in header and footer based on file location
    $adjustedHeader = $header -replace '\.\./(?=css/|Photos/|Logo1\.png|Home-Page/|Book/|Events/|Current-Affairs/|About-Us/|Resources/|Marketplace/)', $relativePath
    $adjustedFooter = $footer -replace '\.\./(?=Photos/|About-Us/|Resources/|Marketplace/|Current-Affairs/|Book/|Events/|Cart/|Login&Register/)', $relativePath
    
    # Combine the parts
    $newContent = $adjustedHeader + "`n" + $mainContent + "`n" + $adjustedFooter
    
    # Save the file
    Set-Content $file.FullName $newContent -Force
}