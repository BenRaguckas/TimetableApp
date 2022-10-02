# Keeping this as refference and notes

Uri parsing seems unneccessary and could likely be handeled with few hardcoded uri extensions:
'default.aspx', 'login.aspx', 'showtimetable.aspx'
Will return to it once I'm able to request at least 1 timetable.
This may cuase some underlying problems thus it will be left out till after. 
Current solution although tedious works sufficently.

When reworking a simple 'entry' url to redirect to current timetable url: 'timetable.ait.ie/2223'
Keeping this combined with hardcoded extensions should work best.

## Step 3
This is an oddone as it requires redirects but http does not follow redirects (302) on POST.
To resolve this, POST is used for obtaining cookies and url (default.aspx). Then followed by GET request.



