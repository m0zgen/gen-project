#!/bin/bash
# Generate script project folder and simple template files
# Created by Yevgeniy Goncharov, http://sys-adm.in

# ---------------------------------------------------------- VARIABLES #

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPTPATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
SCRIPTNAME=`basename "$0"`

# ---------------------------------------------------------- CHECK ARGS #

if [[ -z $1 ]]; then
  echo "Please usage: $SCRIPTNAME \"project-name\""
  exit
fi

if [[ -d $1 ]]; then
  echo "Project folder exist! Please set other name..."
  exit 1
fi

# ---------------------------------------------------------- CREATE PROJECT #

# Example cutting path
# c
projectPath="$1"
extractedName=$(echo "${projectPath##*/}")

# Create work folder and general script file
mkdir $1 && touch $1/$extractedName.sh && chmod +x $1/$extractedName.sh

cat > $1/$extractedName.sh <<EOF
#!/bin/bash
# Add script description
# Created by Yevgeniy Goncharov, http://sys-adm.in

# ---------------------------------------------------------- VARIABLES #

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPTPATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
SCRIPTNAME=`basename "$0"`

# ---------------------------------------------------------- BODYs #

# Enter code here

EOF

# ---------------------------------------------------------- ADD-TO-GIT #
# Script for pulling project into Git repo
touch $1/add-to-git.sh && chmod +x $1/add-to-git.sh

cat > $1/add-to-git.sh <<EOF
#!/bin/bash
# Upload this lib to git
# Created by Yevgeniy Goncharov, http://sys-adm.in

if [[ -z \$1 ]]; then
  echo "Please add commit comment!"
else
  git rm -r --cached .
  git add .
  git commit -m "\$1"
  git push origin master
fi
EOF

# ---------------------------------------------------------- ADD-NEW-SCRIPT #
# Script for generate new script file template
touch $1/add-new-script.sh && chmod +x $1/add-new-script.sh

cat>$1/add-new-script.sh<<EOF
#!/bin/bash
# Add new script to this dir
# Created by Yevgeniy Goncharov, http://sys-adm.in

if [[ -z \$1 ]]; then
  echo "Please set script name.."
else
  # Create and set ex perm
  touch \$1 && chmod +x \$1
  # Add necessary strings
  cat > \$1 <<EOF
#!/bin/bash
# Add script description
# Created by Yevgeniy Goncharov, http://sys-adm.in
EOF

echo -e "EOF\n  subl \$1\nfi" >> $1/add-new-script.sh

# ---------------------------------------------------------- ADD README #

touch $1/README.md

cat > $1/README.md <<EOF
# Project - extractedName

Project description

EOF

# ---------------------------------------------------------- ADD GITIGNORE #
touch $1/.gitignore

cat > $1/.gitignore <<EOF
add-new-script.sh
add-to-git.sh
EOF

# ---------------------------------------------------------- OPEN IN SUBL #
subl $1/$extractedName.sh
