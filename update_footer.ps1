$htmlFiles = Get-ChildItem -Path "c:\Users\Shadrack\Desktop\Tourism Website 4.0" -Filter "*.html" -Recurse

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Add footer CSS link if not present
    if ($content -notmatch '<link rel="stylesheet" href=".*?footer.css">') {
        $content = $content -replace '(</title>)', '$1`n    <link rel="stylesheet" href="../css/footer.css">'
    }
    
    # Replace existing footer with new footer
    $newFooter = @"
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
"@
    
    $content = $content -replace '(?s)<footer.*?</footer>\s*</body>', "$newFooter`n</body>"
    Set-Content $file.FullName $content
}