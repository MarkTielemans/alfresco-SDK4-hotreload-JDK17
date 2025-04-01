# alfresco-SDK4-hotreload-JDK17
Alfresco SDK 4 does not currently support hotreloading/hotswapping code on Java versions beyond JDK 11. This repository shows how to enable platform module hot reloading of code changes on SDK 4 and JDK 17.

This project targets the AIO SDK archetype.

## Caveats

* DCEVM JDK 17 is not currently provided by the DCEVM project, this project uses [OpenJDK build by JetBrains](https://github.com/JetBrains/JetBrainsRuntime/releases) instead
* Docker for Windows does not support file watching/inotify capabilities on bind volumes, which are required for Hotswap Agent to work on a volume
* Hotswap agent cannot reload JAR files
* Tomcat must not run in protected mode
* Hotswap is only supported for Platform, not Share
* The Spring plugin should not be enabled as this is not compatible with the complexity of Platform's multiple contexts

## Use
Incorporate the changes from this repository into:

* your `...-platform-docker` project
* your `...-platform/pom.xml`
* your `docker-compose.yml`

Then:

1. Start the project normally (`run build_start`)
1. Wait until startup has completed and test your features
1. Make desired changes
1. In your `...-platform` module folder, run `mvn clean package exec:exec@hotswap`
1. Your changes should now be reloaded (within limits of the Hotswap Agent Spring-unaware setup)

## TODO

* Test with AMPS
* Test integration tests