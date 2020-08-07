function Get-POCNewPosts ($info) {
    <#
    main function
    recieves class with 
    Title, link, time found
    #>
    if ($info.link -and @($last | ? link -eq $info.Link).Count -eq 0) {
        #Parameter includes title, link and time found

        $info | ft
        return
        #Save parameter to csv
        $info | Export-Csv $file -NoTypeInformation -Append

        $body = $info.title, $info.link -join "`n"
        #Common site name
        $site = $info.link -replace 'https?://(?:www.)?([^/]+).*', '$1'
        #Send Email
        #Send-MailMessage -To $to -From $from -Subject $site -Body $body -SmtpServer $smtpserver -Port $SMTPPort -Credential $cred -usessl
        #Error logging
        if ([bool]$error[0] -and $error[0].exception -notmatch 'module') {
            Get-Date | Add-Content $errorlog
            $error[0] | Add-Content $errorlog 
        }
    }
}

# REDDIT.COM
Get-POCNewPosts (([xml](Invoke-WebRequest -Uri reddit.com/r/powershell/new/.rss).content).feed.entry[0] | ForEach-Object {
    [pscustomobject]@{
        Title = $_.title
        Link = $_.link.href
        Time = Get-Date -f s
    }
})


