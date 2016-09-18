#!/bin/bash

XRTMPFILE=/tmp/.screenlayout.$$.tmp
touch $XRTMPFILE

i=1
DISPLAY=:0 xrandr -q | while read line; do
        if echo "$line" | grep -q --after-context=1 --no-group-separator "\<connected\>"  ; then
                tmp1=`echo "$line" | cut -d " " -f1`
                tmp2=$(DISPLAY=:0 xrandr -q | grep --after-context=1 --no-group-separator "\<$tmp1\>" | grep -v connected | cut -d" " -f4)
                # output in tmp1, resolution in tmp2
                echo -n "$tmp1 $tmp2 " >> $XRTMPFILE
                ((i++))
        fi
done

output_1=`cat $XRTMPFILE | cut -d" " -f1`
resolution_1=`cat $XRTMPFILE | cut -d" " -f2`
output_2=`cat $XRTMPFILE | cut -d" " -f3`
resolution_2=`cat $XRTMPFILE | cut -d" " -f4`

if [ `echo $resolution_1 | cut -d"x" -f1` -ge `echo $resolution_2 | cut -d"x" -f1` ] ; then

        DISPLAY=:0 xrandr --output $output_2 --primary --mode $resolution_2 --pos 0x0 --output $output_1 --mode $resolution_1 --<%= @second_location || 'left' %>-of $output_2
else
        DISPLAY=:0 xrandr --output $output_1 --primary --mode $resolution_1 --pos 0x0 --output $output_2 --mode $resolution_2 --<%= @second_location || 'left' %>-of $output_1
fi

rm -f $XRTMPFILE

exit 0
