$htmlFiles = Get-ChildItem -Path "c:\Users\Shadrack\Desktop\Tourism Website 4.0" -Filter "*.html" -Recurse

foreach ($file in $htmlFiles) {
    $text = Get-Content $file.FullName -Raw
    $occurrences = ([regex]::Matches($text, '(?s)<div\s+class="footer-logo".*?</div>', 'IgnoreCase'))
    if ($occurrences.Count -gt 1) {
        # Backup
        Copy-Item $file.FullName "$($file.FullName).bak" -Force

        # Use the last occurrence's img src if present
        $last = $occurrences[$occurrences.Count - 1].Value
        $imgMatch = [regex]::Match($last, '<img\s+[^>]*src="(?<src>[^"]+)"', 'IgnoreCase')
        $imgSrc = if ($imgMatch.Success) { $imgMatch.Groups['src'].Value } else { '../Photos/NoemaLogo.jpg' }

        # Remove all footer-logo blocks using regex
        $cleaned = [regex]::Replace($text, '(?s)<div\s+class="footer-logo".*?</div>\s*', '', 'IgnoreCase')

        # Build single footer-logo block with the chosen src using a single-quoted here-string for safety
        $footerLogo = @'
    <div class="footer-logo">
        <div class="container">
            <img src="'@ + $imgSrc + '" alt="Company Logo">
        </div>
    </div>
'@

        # Insert before <footer class="footer"> or before </body> using string methods to avoid regex replacement group issues
        $footerIndex = $cleaned.IndexOf('<footer class="footer">', [System.StringComparison]::OrdinalIgnoreCase)
        if ($footerIndex -ge 0) {
            $cleaned = $cleaned.Substring(0, $footerIndex) + $footerLogo + $cleaned.Substring($footerIndex)
        } else {
            $cleaned = $cleaned.Replace('</body>', $footerLogo + '</body>')
        }

        # Ensure only one footer.css link in head: keep the first occurrence if multiple
        $headStart = $cleaned.IndexOf('<head', [System.StringComparison]::OrdinalIgnoreCase)
        $headEnd = $cleaned.IndexOf('</head>', [System.StringComparison]::OrdinalIgnoreCase)
        if ($headStart -ge 0 -and $headEnd -gt $headStart) {
            $head = $cleaned.Substring($headStart, $headEnd - $headStart + 7)
            $cssMatches = [regex]::Matches($head, 'href=".*?footer\.css"', 'IgnoreCase')
            if ($cssMatches.Count -gt 1) {
                $first = $cssMatches[0].Value
                # remove all occurrences
                $headClean = [regex]::Replace($head, '(<link[^>]*href="[^"]*footer\.css"[^>]*>)', '', 'IgnoreCase')
                # insert first right after opening <head>
                $headClean = $headClean -replace '(<head.*?>)', "$1`r`n    $first"
                $cleaned = $cleaned.Substring(0, $headStart) + $headClean + $cleaned.Substring($headEnd + 7)
            }
        }

        Set-Content $file.FullName $cleaned -Force -Encoding UTF8
        Write-Host "Cleaned duplicates in: $($file.FullName)"
    }
}

Write-Host "Finished removing duplicate footer-logo blocks."