module.exports = function (grunt) {
    // Project configuration.
    grunt.initConfig({

        less: {
            bootstrap: {
                options: {
                    cleancss: true
                },
                files: {
                    "web/css/bootstrap.css" : "app/Resources/less/style.less"
                }
            }
        },

        copy: {
            jquery: {
                files: [{
                        expand: true,
                        cwd: 'node_modules/jquery',
                        src: ['dist/**'],
                        dest: 'web/vendor/jquery'
                    }]
            },
            jqueryui: {
                files: [{
                    expand: true,
                    cwd: 'node_modules/components-jqueryui',
                    src: ['**.js', 'themes/base/*.css'],
                    dest: 'web/vendor/components-jqueryui'
                }]
            },
            bootstrap: {
                files: [{
                        expand: true,
                        cwd: 'node_modules/bootstrap',
                        src: ['dist/**'],
                        dest: 'web/vendor/bootstrap'
                    }]
            },
            fonts: {
                files: [{
                    expand: true,
                    cwd: 'node_modules/bootstrap/fonts',
                    src: ['**'],
                    dest: 'web/css/fonts'
                }]
            },
            bootstrapTable: {
                files: [{
                        expand: true,
                        cwd: 'node_modules/bootstrap-table',
                        src: ['dist/**'],
                        dest: 'web/vendor/bootstrap-table'
                    }]
            },
			ckeditor: {
				files: [{
					expand: true,
					cwd: 'node_modules/ckeditor',
					src: ['**', '!**/samples/**', '!**/plugins/**'],
					dest: 'web/vendor/ckeditor'
				}],
			},
            ginco: {
                files: [{
                    expand: true,
                    cwd: 'app/Resources/',
                    src: ['js/**.js', 'css/**.css'],
                    dest: 'web/'
                }]
            }          
        }
    });

    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.registerTask('default', ['less', 'copy']);
};