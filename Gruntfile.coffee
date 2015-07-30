
module.exports = (grunt) ->

    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'

        salt:
            options:
                dryrun:  false
                verbose: false
            style: 
                options:
                    textMarker  : '//!'
                    textPrefix  : '/*'
                    textFill    : '  '
                    textPostfix : '*/'
                files:
                    'asciiText' : ['**/*.swift']

        watch:
          sources:
            files: ['**/*.swift']
            tasks: ['salt']

        clean: ['Build', 'DerivedData']
                            
        shell:
            options:
                execOptions: 
                    maxBuffer: Infinity
            kill:
                command: "killall krkklapp || echo 1"
            build: 
                command: "xcodebuild -target krkklapp"
            test: 
                command: "open Build/Release/krkklapp.app"
                
    ###
    npm install --save-dev grunt-contrib-watch
    npm install --save-dev grunt-contrib-clean
    npm install --save-dev grunt-pepper
    npm install --save-dev grunt-shell
    ###

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-pepper'
    grunt.loadNpmTasks 'grunt-shell'

    grunt.registerTask 'build',     [ 'clean', 'salt', 'shell:build' ]
    grunt.registerTask 'test',      [ 'build', 'shell:kill', 'shell:test' ]
    grunt.registerTask 'default',   [ 'test' ]
