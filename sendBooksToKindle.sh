#!/usr/bin/env bash

# This script is triggered by fswatch detecting a file change in my Books folder, and checks if there are any
# new books added using the folder state in the log.txt file. If it notices the new folder state is different 
# than the older state, AKA new books have been added, it will send the new books to my kindle email, and save
# the new log state.  


# Function
# if book exists in old log --> return 1 (false)
#  else --> return 0 (true)
function check_if_new() {
    local string=$1
    shift
    local arr=("$@")

    if [ ${#arr[@]} -eq 0 ]; then
        return 0
    fi
    
    for title in "${arr[@]}"; do 
        if [[ "$title" = "$string" ]] 
        then 
            return 1
        else
            continue
        fi 
    exit 0
    done
}


#1. Navigate to Desktop/Books folder
cd ~/Desktop/Books

#2. Grab array of old folder state books from old log.txt file
arr=()
while IFS= read -r line || [[ "$line" ]]; do
  arr+=("$line")
done < log.txt


#3. Grab all current books and check if new. If new --> email to Kindle 
for f in *; do
    if [[ $f == *.epub ]] || [[ $f == *.pdf ]] || [[ $f == *.mobi ]];
    then
        check_if_new "$f" "${arr[@]}"
        res=$?
        if [[ $res = 0 ]]
        then 
            echo "New book, sending to kindle: "$f""
            #Send email to Kindle
            mutt -s "Uploading book from mutt" -a "$f" -- < /dev/null "$KINDLE_EMAIL"
        else
            echo "Old book, doing nothing"
        fi
    else
        continue
    fi 
done

#4. Create new log file 
touch "log1.txt"

for f in *; do
    if [[ $f == *.epub ]] || [[ $f == *.pdf ]] || [[ $f == *.mobi ]];
    then
        echo "$f" >> "log1.txt"
    else
        continue
    fi
done

#5. Replace old log file with contents of new log file
mv "log1.txt" "log.txt"     


# TODO
#1. Modularize functions, possibly extract to separate files for reuse. 
#2. Maybe create commmon.sh for common functions to resuse