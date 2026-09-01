

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.3")
    }
}

// Repositories block for all projects/modules
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Move build directory two levels up
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Change build directory for each subproject
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Evaluate each subproject after `:app`
    evaluationDependsOn(":app")
}

// Custom clean task to delete centralized build folder
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
