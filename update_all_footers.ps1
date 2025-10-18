$htmlFiles = Get-ChildItem -Path . -Filter *.html -Recurse -File

foreach ($file in $htmlFiles) {
    # Skip .bak files
    if ($file.Name -like "*.bak") {
        continue
    }

    # Create backup
    Copy-Item -Path $file.FullName -Destination "$($file.FullName).bak" -Force
    
    # Calculate relative path to root
    $relativePath = "../" * ($file.FullName.Split("\") | Where-Object { $_ -ne "" } | Measure-Object).Count
    $relativePath = $relativePath -replace "\.\.\/\.\.\/\.\.\/[^\/]+\/", "../"
    
    # Read file content
    $content = Get-Content -Path $file.FullName -Raw

    # Ensure footer CSS is present and correctly linked
    if ($content -notmatch '<link rel="stylesheet" href=".*?footer\.css">') {
        $content = $content -replace '(</title>)', "`$1`n    <link rel=`"stylesheet`" href=`"$($relativePath)css/footer.css`">"
    }

    # Replace existing footer content
    $newFooter = @"
    <!-- FOOTER LOGO -->
    <div class="footer-logo">
        <div class="container">
            <img src="$($relativePath)Photos/NoemaLogo.jpg" alt="Company Logo">
        </div>
    </div>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="footer-col">
                    <h4>Support</h4>
                    <ul>
                        <li><a href="$($relativePath)About-Us/About.html">about us</a></li>
                        <li><a href="$($relativePath)Resources/Resources.html">our services</a></li>
                        <li><a href="#">privacy policy</a></li>
                        <li><a href="#">Terms and Conditions</a></li>
                        <li><a href="$($relativePath)Login&Register/Login.html">Login</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Explore</h4>
                    <ul>
                        <li><a href="$($relativePath)Marketplace/Marketplace.html">Marketplace</a></li>
                        <li><a href="$($relativePath)Current-Affairs/news.html">News</a></li>
                        <li><a href="$($relativePath)Book/Book.html">Booking</a></li>
                        <li><a href="$($relativePath)Events/Events.html">Events</a></li>
                        <li><a href="$($relativePath)Cart/cart.html">Shopping Cart</a></li>
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

    # Remove any duplicate closing tags
    $newFooter = $newFooter -replace '</html>\s*</html>\s*</html>\s*</html>\s*$', '</html>'

    # Replace everything from footer-logo to the end of file
    $content = $content -replace '(?s)<!-- FOOTER LOGO -->.*?</html>\s*$', $newFooter

    # Save the file
    $content | Set-Content -Path $file.FullName -Force
    Write-Host "Updated footer in $($file.Name)"
}

Write-Host "Footer update complete!"