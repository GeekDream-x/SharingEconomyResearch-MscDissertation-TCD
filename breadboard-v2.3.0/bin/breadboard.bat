@REM breadboard launcher script
@REM
@REM Envioronment:
@REM JAVA_HOME - location of a JDK home dir (optional if java on path)
@REM CFG_OPTS  - JVM options (optional)
@REM Configuration:
@REM BREADBOARD_config.txt found in the BREADBOARD_HOME.
@setlocal enabledelayedexpansion

@echo off
if "%BREADBOARD_HOME%"=="" set "BREADBOARD_HOME=%~dp0\\.."
set ERROR_CODE=0

set "APP_LIB_DIR=%BREADBOARD_HOME%\lib\"

rem Detect if we were double clicked, although theoretically A user could
rem manually run cmd /c
for %%x in (%cmdcmdline%) do if %%~x==/c set DOUBLECLICKED=1

rem FIRST we load the config file of extra options.
set "CFG_FILE=%BREADBOARD_HOME%\BREADBOARD_config.txt"
set CFG_OPTS=
if exist %CFG_FILE% (
  FOR /F "tokens=* eol=# usebackq delims=" %%i IN ("%CFG_FILE%") DO (
    set DO_NOT_REUSE_ME=%%i
    rem ZOMG (Part #2) WE use !! here to delay the expansion of
    rem CFG_OPTS, otherwise it remains "" for this loop.
    set CFG_OPTS=!CFG_OPTS! !DO_NOT_REUSE_ME!
  )
)

rem We use the value of the JAVACMD environment variable if defined
set _JAVACMD=%JAVACMD%

if "%_JAVACMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\java.exe" set "_JAVACMD=%JAVA_HOME%\bin\java.exe"
  )
)

if "%_JAVACMD%"=="" set _JAVACMD=java

rem Detect if this java is ok to use.
for /F %%j in ('"%_JAVACMD%" -version  2^>^&1') do (
  if %%~j==Java set JAVAINSTALLED=1
)

rem Detect the same thing about javac
if "%_JAVACCMD%"=="" (
  if not "%JAVA_HOME%"=="" (
    if exist "%JAVA_HOME%\bin\javac.exe" set "_JAVACCMD=%JAVA_HOME%\bin\javac.exe"
  )
)
if "%_JAVACCMD%"=="" set _JAVACCMD=javac
for /F %%j in ('"%_JAVACCMD%" -version 2^>^&1') do (
  if %%~j==javac set JAVACINSTALLED=1
)

rem BAT has no logical or, so we do it OLD SCHOOL! Oppan Redmond Style
set JAVAOK=true
if not defined JAVAINSTALLED set JAVAOK=false
rem TODO - JAVAC is an optional requirement.
if not defined JAVACINSTALLED set JAVAOK=false

if "%JAVAOK%"=="false" (
  echo.
  echo A Java JDK is not installed or can't be found.
  if not "%JAVA_HOME%"=="" (
    echo JAVA_HOME = "%JAVA_HOME%"
  )
  echo.
  echo Please go to
  echo   http://www.oracle.com/technetwork/java/javase/downloads/index.html
  echo and download a valid Java JDK and install before running breadboard.
  echo.
  echo If you think this message is in error, please check
  echo your environment variables to see if "java.exe" and "javac.exe" are
  echo available via JAVA_HOME or PATH.
  echo.
  if defined DOUBLECLICKED pause
  exit /B 1
)


rem We use the value of the JAVA_OPTS environment variable if defined, rather than the config.
set _JAVA_OPTS=%JAVA_OPTS%
if "%_JAVA_OPTS%"=="" set _JAVA_OPTS=%CFG_OPTS%

:run
 
set "APP_CLASSPATH=%APP_LIB_DIR%\breadboard.breadboard-v2.3.0.jar;%APP_LIB_DIR%\org.scala-lang.scala-library-2.10.2.jar;%APP_LIB_DIR%\com.typesafe.play.play_2.10-2.2.0.jar;%APP_LIB_DIR%\com.typesafe.play.sbt-link-2.2.0.jar;%APP_LIB_DIR%\org.javassist.javassist-3.18.0-GA.jar;%APP_LIB_DIR%\com.typesafe.play.play-exceptions-2.2.0.jar;%APP_LIB_DIR%\com.typesafe.play.templates_2.10-2.2.0.jar;%APP_LIB_DIR%\com.github.scala-incubator.io.scala-io-file_2.10-0.4.2.jar;%APP_LIB_DIR%\com.github.scala-incubator.io.scala-io-core_2.10-0.4.2.jar;%APP_LIB_DIR%\com.jsuereth.scala-arm_2.10-1.3.jar;%APP_LIB_DIR%\com.typesafe.play.play-iteratees_2.10-2.2.0.jar;%APP_LIB_DIR%\org.scala-stm.scala-stm_2.10-0.7.jar;%APP_LIB_DIR%\com.typesafe.config-1.0.2.jar;%APP_LIB_DIR%\com.typesafe.play.play-json_2.10-2.2.0.jar;%APP_LIB_DIR%\com.typesafe.play.play-functional_2.10-2.2.0.jar;%APP_LIB_DIR%\com.typesafe.play.play-datacommons_2.10-2.2.0.jar;%APP_LIB_DIR%\org.joda.joda-convert-1.3.1.jar;%APP_LIB_DIR%\org.scala-lang.scala-reflect-2.10.2.jar;%APP_LIB_DIR%\io.netty.netty-3.7.0.Final.jar;%APP_LIB_DIR%\com.typesafe.netty.netty-http-pipelining-1.1.2.jar;%APP_LIB_DIR%\org.slf4j.slf4j-api-1.7.5.jar;%APP_LIB_DIR%\org.slf4j.jul-to-slf4j-1.7.5.jar;%APP_LIB_DIR%\org.slf4j.jcl-over-slf4j-1.7.5.jar;%APP_LIB_DIR%\ch.qos.logback.logback-core-1.0.13.jar;%APP_LIB_DIR%\ch.qos.logback.logback-classic-1.0.13.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-actor_2.10-2.2.0.jar;%APP_LIB_DIR%\com.typesafe.akka.akka-slf4j_2.10-2.2.0.jar;%APP_LIB_DIR%\org.apache.commons.commons-lang3-3.1.jar;%APP_LIB_DIR%\com.ning.async-http-client-1.7.18.jar;%APP_LIB_DIR%\oauth.signpost.signpost-core-1.2.1.2.jar;%APP_LIB_DIR%\oauth.signpost.signpost-commonshttp4-1.2.1.2.jar;%APP_LIB_DIR%\xerces.xercesImpl-2.11.0.jar;%APP_LIB_DIR%\xml-apis.xml-apis-1.4.01.jar;%APP_LIB_DIR%\javax.transaction.jta-1.1.jar;%APP_LIB_DIR%\com.typesafe.play.play-java_2.10-2.2.0.jar;%APP_LIB_DIR%\org.yaml.snakeyaml-1.12.jar;%APP_LIB_DIR%\org.hibernate.hibernate-validator-5.0.1.Final.jar;%APP_LIB_DIR%\javax.validation.validation-api-1.1.0.Final.jar;%APP_LIB_DIR%\org.jboss.logging.jboss-logging-3.1.1.GA.jar;%APP_LIB_DIR%\com.fasterxml.classmate-0.8.0.jar;%APP_LIB_DIR%\org.springframework.spring-context-3.2.3.RELEASE.jar;%APP_LIB_DIR%\org.springframework.spring-core-3.2.3.RELEASE.jar;%APP_LIB_DIR%\org.springframework.spring-beans-3.2.3.RELEASE.jar;%APP_LIB_DIR%\org.reflections.reflections-0.9.8.jar;%APP_LIB_DIR%\dom4j.dom4j-1.6.1.jar;%APP_LIB_DIR%\com.google.guava.guava-14.0.1.jar;%APP_LIB_DIR%\com.google.code.findbugs.jsr305-2.0.1.jar;%APP_LIB_DIR%\javax.servlet.javax.servlet-api-3.0.1.jar;%APP_LIB_DIR%\com.typesafe.play.play-java-jdbc_2.10-2.2.0.jar;%APP_LIB_DIR%\com.typesafe.play.play-jdbc_2.10-2.2.0.jar;%APP_LIB_DIR%\com.jolbox.bonecp-0.8.0-rc1.jar;%APP_LIB_DIR%\com.h2database.h2-1.3.172.jar;%APP_LIB_DIR%\tyrex.tyrex-1.0.1.jar;%APP_LIB_DIR%\com.typesafe.play.play-java-ebean_2.10-2.2.0.jar;%APP_LIB_DIR%\org.avaje.ebeanorm.avaje-ebeanorm-3.2.2.jar;%APP_LIB_DIR%\org.avaje.ebeanorm.avaje-ebeanorm-agent-3.2.1.jar;%APP_LIB_DIR%\org.hibernate.javax.persistence.hibernate-jpa-2.0-api-1.0.1.Final.jar;%APP_LIB_DIR%\antlr.antlr-2.7.7.jar;%APP_LIB_DIR%\asm.asm-3.2.jar;%APP_LIB_DIR%\asm.asm-commons-3.2.jar;%APP_LIB_DIR%\asm.asm-tree-3.2.jar;%APP_LIB_DIR%\asm.asm-util-3.2.jar;%APP_LIB_DIR%\asm.asm-analysis-3.2.jar;%APP_LIB_DIR%\com.tinkerpop.blueprints.blueprints-core-2.5.0.jar;%APP_LIB_DIR%\org.codehaus.jettison.jettison-1.3.3.jar;%APP_LIB_DIR%\stax.stax-api-1.0.1.jar;%APP_LIB_DIR%\com.fasterxml.jackson.datatype.jackson-datatype-json-org-2.2.3.jar;%APP_LIB_DIR%\org.json.json-20090211.jar;%APP_LIB_DIR%\colt.colt-1.2.0.jar;%APP_LIB_DIR%\concurrent.concurrent-1.3.4.jar;%APP_LIB_DIR%\commons-configuration.commons-configuration-1.6.jar;%APP_LIB_DIR%\commons-collections.commons-collections-3.2.1.jar;%APP_LIB_DIR%\commons-lang.commons-lang-2.4.jar;%APP_LIB_DIR%\commons-digester.commons-digester-1.8.jar;%APP_LIB_DIR%\commons-beanutils.commons-beanutils-1.7.0.jar;%APP_LIB_DIR%\commons-beanutils.commons-beanutils-core-1.8.0.jar;%APP_LIB_DIR%\com.tinkerpop.blueprints.blueprints-graph-jung-2.5.0.jar;%APP_LIB_DIR%\net.sf.jung.jung-api-2.0.1.jar;%APP_LIB_DIR%\net.sourceforge.collections.collections-generic-4.01.jar;%APP_LIB_DIR%\net.sf.jung.jung-algorithms-2.0.1.jar;%APP_LIB_DIR%\net.sf.jung.jung-visualization-2.0.1.jar;%APP_LIB_DIR%\com.tinkerpop.gremlin.gremlin-groovy-2.5.0.jar;%APP_LIB_DIR%\com.tinkerpop.gremlin.gremlin-java-2.5.0.jar;%APP_LIB_DIR%\com.tinkerpop.pipes-2.5.0.jar;%APP_LIB_DIR%\org.apache.ivy.ivy-2.3.0.jar;%APP_LIB_DIR%\org.codehaus.groovy.groovy-1.8.9.jar;%APP_LIB_DIR%\org.apache.ant.ant-1.8.3.jar;%APP_LIB_DIR%\org.apache.ant.ant-launcher-1.8.3.jar;%APP_LIB_DIR%\org.fusesource.jansi.jansi-1.5.jar;%APP_LIB_DIR%\jline.jline-0.9.94.jar;%APP_LIB_DIR%\commons-io.commons-io-2.3.jar;%APP_LIB_DIR%\org.apache.commons.commons-csv-1.5.jar;%APP_LIB_DIR%\net.lingala.zip4j.zip4j-1.3.2.jar;%APP_LIB_DIR%\org.imgscalr.imgscalr-lib-4.2.jar;%APP_LIB_DIR%\org.mindrot.jbcrypt-0.3m.jar;%APP_LIB_DIR%\com.google.code.gson.gson-2.8.2.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-servicediscovery-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-core-1.11.245.jar;%APP_LIB_DIR%\commons-logging.commons-logging-1.1.3.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpclient-4.5.2.jar;%APP_LIB_DIR%\org.apache.httpcomponents.httpcore-4.4.4.jar;%APP_LIB_DIR%\commons-codec.commons-codec-1.9.jar;%APP_LIB_DIR%\software.amazon.ion.ion-java-1.0.2.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-databind-2.6.7.1.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-annotations-2.6.0.jar;%APP_LIB_DIR%\com.fasterxml.jackson.core.jackson-core-2.6.7.jar;%APP_LIB_DIR%\com.fasterxml.jackson.dataformat.jackson-dataformat-cbor-2.6.7.jar;%APP_LIB_DIR%\joda-time.joda-time-2.8.1.jar;%APP_LIB_DIR%\com.amazonaws.jmespath-java-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cloud9-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-serverlessapplicationrepository-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-alexaforbusiness-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-resourcegroups-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-comprehend-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-translate-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-sagemaker-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-iotjobsdataplane-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-sagemakerruntime-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-kinesisvideo-1.11.245.jar;%APP_LIB_DIR%\io.netty.netty-codec-http-4.1.17.Final.jar;%APP_LIB_DIR%\io.netty.netty-codec-4.1.17.Final.jar;%APP_LIB_DIR%\io.netty.netty-transport-4.1.17.Final.jar;%APP_LIB_DIR%\io.netty.netty-buffer-4.1.17.Final.jar;%APP_LIB_DIR%\io.netty.netty-common-4.1.17.Final.jar;%APP_LIB_DIR%\io.netty.netty-resolver-4.1.17.Final.jar;%APP_LIB_DIR%\io.netty.netty-handler-4.1.17.Final.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-appsync-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-guardduty-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-mq-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-mediaconvert-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-mediastore-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-mediastoredata-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-medialive-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-mediapackage-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-costexplorer-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-pricing-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-mobile-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cloudhsmv2-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-glue-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-migrationhub-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-dax-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-greengrass-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-athena-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-marketplaceentitlement-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-codestar-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-lexmodelbuilding-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-resourcegroupstaggingapi-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-pinpoint-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-xray-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-opsworkscm-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-support-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-simpledb-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-servicecatalog-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-servermigration-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-simpleworkflow-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-storagegateway-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-route53-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-s3-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-kms-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-importexport-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-sts-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-sqs-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-rds-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-redshift-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-elasticbeanstalk-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-glacier-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-sns-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-iam-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-datapipeline-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-elasticloadbalancing-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-elasticloadbalancingv2-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-emr-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-elasticache-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-elastictranscoder-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-ec2-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-dynamodb-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-budgets-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cloudtrail-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cloudwatch-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-logs-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-events-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cognitoidentity-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cognitosync-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-directconnect-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cloudformation-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cloudfront-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-clouddirectory-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-kinesis-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-opsworks-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-ses-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-autoscaling-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cloudsearch-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cloudwatchmetrics-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-codedeploy-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-codepipeline-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-config-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-lambda-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-ecs-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-ecr-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cloudhsm-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-ssm-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-workspaces-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-machinelearning-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-directory-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-efs-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-codecommit-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-devicefarm-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-elasticsearch-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-waf-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-marketplacecommerceanalytics-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-inspector-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-iot-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-api-gateway-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-acm-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-gamelift-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-dms-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-marketplacemeteringservice-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-cognitoidp-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-discovery-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-applicationautoscaling-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-snowball-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-rekognition-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-polly-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-lightsail-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-stepfunctions-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-health-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-costandusagereport-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-codebuild-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-appstream-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-shield-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-batch-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-lex-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-mechanicalturkrequester-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-organizations-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-workdocs-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-models-1.11.245.jar;%APP_LIB_DIR%\com.amazonaws.aws-java-sdk-swf-libraries-1.11.22.jar"
set "APP_MAIN_CLASS=play.core.server.NettyServer"

rem TODO - figure out how to pass arguments....
"%_JAVACMD%" %_JAVA_OPTS% %BREADBOARD_OPTS% -cp "%APP_CLASSPATH%" %APP_MAIN_CLASS% %CMDS%
if ERRORLEVEL 1 goto error
goto end

:error
set ERROR_CODE=1

:end

@endlocal

exit /B %ERROR_CODE%
