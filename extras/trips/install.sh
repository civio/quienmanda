# Use `bash install.sh` to run this script
# (https://chriskief.com/2014/02/28/simple-grunt-configuration-for-sass-coffeescript/)

# install sass
#sudo gem install sass

# install grunt cli globally
#sudo npm install -g grunt-cli

# note - switch to project directory where Gruntfile.coffee and package.json are sitting

# install dependencies
npm install

# run it (default is to watch both sass and coffeescript files)
grunt

# other tasks (compile once)
grunt sass
grunt coffee
grunt uglify
grunt cssmin

# you can also explicitly call the watch task
grunt watch

# all commands are detailed by running the following
grunt --help