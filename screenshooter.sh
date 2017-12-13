#!/bin/bash


#
# Author: Devin M. Alexander 2017
# 
# Parameters: ./screenshooter.sh (# of screenshots) (Width) (Height) (x) (y) (destination) (start frequency) (end frequency)
#
# # of screenshots: The desired number of screenshots to be snapped.
# Width: The desired width of the final output.
# Height: The desired height of the final output.
# x: The x coordinate of the original image from which to begin cropping.
# y: The y coordinate of the original image from which to begin cropping.
# destination: The final destination for the cropped image.
# start frequency: the initial frequency that the application will center on
# end frequency: the center frequency where images will cease to be taken
#
# 
# This automates the capturing of WBT screenshots to be classified by 
# TensorFlow. 
#
# ****** You must have ImageMagick installed for this to work. ****** 
#
# 
# This tool captures images from the WBT. In order for his to work correctly, 
# VNCViewer must position the X11 window in the upper left-most position,
# coordinate 0,0. This will enable the mousedotool to click in the correct
# position. 
# 
# The tool begins by centering the image at the (start frequency). It then snaps
# the (# of screenshots) and save them to the (destination). It will then shift
# the center frequency two units to the left, at which point it will continue
# the above procedure. When the (end frequency) is reached, the program will
# terminate. 
#
# 


iterations=$1

width=$2
height=$3
x=$4
y=$5
i=0
freqCount=$7
freqStop=$8
ones=0
tens=0
hundreds=0
thousands=0


while [  $freqCount -lt $freqStop ]
do
	let i=0
        let ones=$((freqCount%10))
        let tens=$((freqCount/10%10))
        let hundreds=$((freqCount/100%10))
        let thousands=$(((freqCount/1000)%10))

	# Click on the area of the screen to input frequency center
        xdotool mousemove 443 176 click 1
        sleep 0.5

        xdotool key $thousands
        sleep 0.1
        xdotool key $hundreds
        sleep 0.1
        xdotool key $tens
        sleep 0.1
        xdotool key $ones
        sleep 0.1
        xdotool key KP_Enter

	sleep 7

	while [ $i -lt $iterations ]; do
		date=$(date +%s)
		let i=i+1
		gnome-screenshot -d 1 -w --file=$date.png
	done

	#Convert all png files to jpgs for tenosorflow recognition 
	mogrify -format jpg *.png
	
	#Remove all png files, as they are now duplicates
	rm *.png


	for f in *.jpg
	do
		dt=$(date +%s%N)
		convert -crop ${width}x$height+$x+$y $f ${6}/${dt}.jpg
		rm $f
	done

	let freqCount=$((freqCount+2))
done	

 
