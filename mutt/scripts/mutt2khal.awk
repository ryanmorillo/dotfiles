#!/usr/bin/awk -f
# read from ical_filter.pl and then send ical invitation details 
# in mutt to khal

/^Summary/   { for (i=1; i<=NF-2; i++) $i = $(i+2); NF-=2; summ = $0 }
/^Location/  { for (i=1; i<=NF-2; i++)
   	$i = $(i+2);
   	NF-=2;
   	meet = $0; gsub(/ /,"_",meet)}
/^Description/  { for (i=1; i<=NF-2; i++) $i = $(i+2); NF-=2; desc = $0 }
/^Dtstart/   { date_st = $3; time_st = $4 }
/^Dtend/     { time_nd = $4 }

END          { print  date_st " " time_st " " time_nd   " --location="meet"  '"summ"' :: '"desc"' "}
