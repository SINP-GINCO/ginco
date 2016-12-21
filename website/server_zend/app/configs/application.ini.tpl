; This file is a model template. 
; You can either copy it and rename it 'application.ini', and replace the variable by your own values.

[production]

; Debug output
phpSettings.display_startup_errors = 0
phpSettings.display_errors = 0

; PHP Date Settings
phpSettings.date.timezone = "Europe/Paris"

; Include path
includePaths.library = APPLICATION_PATH "/../library"

; Bootstrap
bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
bootstrap.class = "Bootstrap"

; Application Namespaces
appnamespace = "Application"

; Autoloader Namespaces
autoloaderNamespaces[] = "Genapp_"

; FrontController
resources.frontController.controllerDirectory.default = APPLICATION_PATH "/controllers"
resources.frontController.controllerDirectory.custom = CUSTOM_APPLICATION_PATH "/controllers"
resources.frontController.baseUrl = "/"; The trailing slash is important
resources.frontController.params.displayExceptions = 0
resources.frontController.params.env = APPLICATION_ENV

; Layout
resources.layout.layout = "layout"
resources.layout.layoutPath = CUSTOM_APPLICATION_PATH "/layouts/scripts"

; Views
resources.view.contentType = "text/html; charset=UTF-8"
resources.view.encoding = "UTF-8"

; Logs
resources.log.stream.writerName = "Stream"
resources.log.stream.writerParams.stream = APPLICATION_PATH "/../../../logs/" DATE_STAMP ".log"
resources.log.stream.writerParams.mode = "a"
resources.log.stream.formatterName = "Simple"
resources.log.stream.formatterParams.format = "%timestamp% %priorityName% : %message%" PHP_EOL
resources.log.stream.filterName = "Priority"
resources.log.stream.filterParams.priority = Zend_Log::DEBUG

; Database
resources.db.adapter = "pdo_pgsql"
resources.db.params.host = @db.host@
resources.db.params.port = @db.port@
resources.db.params.username = @db.user@
resources.db.params.password = @db.user.pw@
resources.db.params.dbname = @db.name@
resources.db.isDefaultTableAdapter = true
resources.db.defaultMetadataCache = "database"

resources.multidb.metadata_db.adapter = "pdo_pgsql"
resources.multidb.metadata_db.host = @db.host@
resources.multidb.metadata_db.port = @db.port@
resources.multidb.metadata_db.username = @db.user@
resources.multidb.metadata_db.password = @db.user.pw@
resources.multidb.metadata_db.dbname = @db.name@
resources.multidb.metadata_db.default = true

resources.multidb.website_db.adapter = "pdo_pgsql"
resources.multidb.website_db.host = @db.host@
resources.multidb.website_db.port = @db.port@
resources.multidb.website_db.username = @db.user@
resources.multidb.website_db.password = @db.user.pw@
resources.multidb.website_db.dbname = @db.name@
resources.multidb.website_db.default = false

resources.multidb.mapping_db.adapter = "pdo_pgsql"
resources.multidb.mapping_db.host = @db.host@
resources.multidb.mapping_db.port = @db.port@
resources.multidb.mapping_db.username = @db.user@
resources.multidb.mapping_db.password = @db.user.pw@
resources.multidb.mapping_db.dbname = @db.name@
resources.multidb.mapping_db.default = false

resources.multidb.raw_db.adapter = "pdo_pgsql"
resources.multidb.raw_db.host = @db.host@
resources.multidb.raw_db.port = @db.port@
resources.multidb.raw_db.username = @db.user@
resources.multidb.raw_db.password = @db.user.pw@
resources.multidb.raw_db.dbname = @db.name@
resources.multidb.raw_db.default = false

resources.multidb.harmonized_db.adapter = "pdo_pgsql"
resources.multidb.harmonized_db.host = @db.host@
resources.multidb.harmonized_db.port = @db.port@
resources.multidb.harmonized_db.username = @db.user@
resources.multidb.harmonized_db.password = @db.user.pw@
resources.multidb.harmonized_db.dbname = @db.name@
resources.multidb.harmonized_db.default = false

; Session
resources.session.name = "@instance.name@_GINCO_SID"
resources.session.cookie_domain = ".ign.fr"
resources.session.hash_function = "1"
resources.session.cookie_httponly = on
resources.session.use_cookies = on
resources.session.use_only_cookies = on
resources.session.save_path = APPLICATION_PATH "/../sessions"
resources.session.gc_maxlifetime = 18000
resources.session.remember_me_seconds = 18000

; Router
; Default Routes
resources.router.routes.defaultController.route = "/:controller/:action"
resources.router.routes.defaultController.defaults.module = default
resources.router.routes.defaultController.defaults.controller = index
resources.router.routes.defaultController.defaults.action = index

; Locale
resources.locale.default = "fr_FR"

; Translate
resources.translate.adapter = csv
resources.translate.locale = fr_FR ; default locale
resources.translate.content = APPLICATION_PATH "/lang/fr.csv" ; default content
resources.translate.scan = Zend_Translate::LOCALE_DIRECTORY
resources.translate.logUntranslated = true
resources.translate.logMessage = "Missing '%message%' within locale '%locale%'"
resources.translate.cache = "language"

; Cache Manager
resources.cachemanager.database.frontend.name = Core
resources.cachemanager.database.frontend.customFrontendNaming = false
resources.cachemanager.database.frontend.options.lifetime = 7200
resources.cachemanager.database.frontend.options.automatic_serialization = true
resources.cachemanager.database.backend.name = File
resources.cachemanager.database.backend.customBackendNaming = false
resources.cachemanager.database.backend.options.cache_dir = APPLICATION_PATH "/../tmp/database"
resources.cachemanager.database.frontendBackendAutoload = false

resources.cachemanager.language.frontend.name = Core
resources.cachemanager.language.frontend.customFrontendNaming = false
resources.cachemanager.language.frontend.options.lifetime = 7200
resources.cachemanager.language.frontend.options.automatic_serialization = true
resources.cachemanager.language.backend.name = File
resources.cachemanager.language.backend.customBackendNaming = false
resources.cachemanager.language.backend.options.cache_dir = APPLICATION_PATH "/../tmp/language"
resources.cachemanager.language.frontendBackendAutoload = false

resources.cachemanager.fileindex.frontend.name = Core
resources.cachemanager.fileindex.frontend.customFrontendNaming = false
resources.cachemanager.fileindex.frontend.options.lifetime = 7200
resources.cachemanager.fileindex.frontend.options.automatic_serialization = true
resources.cachemanager.fileindex.backend.name = File
resources.cachemanager.fileindex.backend.customBackendNaming = false
resources.cachemanager.fileindex.backend.options.cache_dir = APPLICATION_PATH "/../tmp/fileindex"
resources.cachemanager.fileindex.frontendBackendAutoload = false

[development : production]

; Database
resources.db.params.host = @db.host@
resources.db.params.port = 5432
resources.db.params.username = ogam
resources.db.params.password = ogam
resources.db.params.dbname = sinp

; Debug output
phpSettings.display_startup_errors = 1
phpSettings.display_errors = 1

; Front Controller
resources.frontController.params.displayExceptions = 1

; Session
resources.session.use_only_cookies = on
resources.session.remember_me_seconds = 864000

; Environnemment spécifique aux tests unitaires, pour l'instant uniquement pour php
[phpunit : production]

; Database
resources.db.params.dbname = @db.name@
; Debug output
phpSettings.display_startup_errors = 1
phpSettings.display_errors = 1

; Surchage des dossiers de cache pour les tests unitaires
resources.cachemanager.fileindex.backend.options.cache_dir = TEST_PATH "tmp/"
resources.cachemanager.language.backend.options.cache_dir = TEST_PATH "tmp/"
resources.cachemanager.database.backend.options.cache_dir = TEST_PATH "tmp/"

; Logs
resources.log.stream.writerName = "Stream"
resources.log.stream.writerParams.stream = TEST_PATH "logs/" DATE_STAMP ".log"
resources.log.stream.writerParams.mode = "a"
resources.log.stream.formatterName = "Simple"
resources.log.stream.formatterParams.format = "%timestamp% %priorityName% : %message%" PHP_EOL
resources.log.stream.filterName = "Priority"
resources.log.stream.filterParams.priority = Zend_Log::DEBUG
