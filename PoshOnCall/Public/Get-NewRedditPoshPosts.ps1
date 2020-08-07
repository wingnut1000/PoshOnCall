Function Get-NewRedditPoshPosts {
    ([xml](Invoke-WebRequest -Uri reddit.com/r/powershell/new/.rss).content).feed.entry[0..1] | ForEach-Object {
        [pscustomobject]@{
            Title = $_.title
            Link = $_.link.href
            Time = Get-Date -f s
        }
    }
}




$a = ([xml](Invoke-WebRequest -Uri reddit.com/r/powershell/new/.rss).content).feed.entry[0]
return


$posts = Get-NewRedditPoshPosts
foreach ($post in $posts){
    $PostButton = New-BTButton -Content 'Open Post' -Arguments $post.Link
    New-BurntToastNotification -Text $post.Title -Button $PostButton
}