<h1>The Health Research Portal</h1>

<h2>Introduction</h2>

<p>
The Health Research Portal (HRP) is an <i><b>integrated online health research management system </b></i>that offers substantial benefits for all stakeholders in health research. The Portal aims to improve accountability, efficiency and quality of health research conducted in country by providing information on all ongoing research and hence increasing transparency and by streamlining the review process.
</p>

<p>
The Portal can be used to:
<ul>
<li><b>Submit research proposals </b>for review to one of the ethics committee of the country, 24x7, from anywhere. Researchers need to register on the Portal. Once registered, the user will have a permanent account and be able to submit research proposal in a paper-less way and to track the review status of his/her proposals.</li>
<li><b>Search ongoing and completed health research </b>from the launch of the system onwards through a publicly accessible research registry. No registration or log-in is required.</li>
<li><b>Access complete research reports </b>for the researches started since the launch, once the research is completed.</li>
<li><b>Access information on all the applicable guidelines, rules, and regulations </b>related to health research.</li>
<li><b>Access a “Researchers' Directory”</b>containing information on the national and international researchers doing research in the country.</li>
<li><b>Obtain statistics on health research in the country </b>using the metadata of the researches registered (restricted access).</li>
</ul>
</p>

<h2>Features</h2>

<p>
Below are the main features that the Health Research Portal possesses. For a deeper understanding of the system, we recommend you to try it or to take a look to the user manuals included in the source code above.
<ul>
<li>Different user roles (investigator, ethics committee member, coordinator of health research in the country/region...) with restricted access.</li>
<li>Management of multiple ethics committees with respect of the confidentiality.</li>
<li>Submission / Re-submission / Amendment / Adverse-event of a health research.</li>
<li>Organized storage of the research documents with restricted access.</li>
<li>Custom generation of data sets (CSV) or charts using the metadata entered for each research proposal.</li>
<li>Generation of approval notices, customizable for each committee.</li>
<li>Generation of customizable PDF cover and disclaimer for the completion reports.</li>
<li>Management of the funding agencies, research fields / domains, proposal types and geographical areas.</li>
<li>Management of the content of the publicly accessible part of the system.</li>
</ul>
</p>


<h2>Installation</h2>
<p>
The Health Research Portal is based on  the Open Journal System (OJS) v. 2.3.4 of the Public Knowledge Project. Numerous references to OJS are still disseminated throughout the HRP. If you cannot find the information you are looking for into the manuals, we would recommend you to take a look to the  <a href="https://pkp.sfu.ca/ojs/">PKP-OJS website</a>. The HRP might still contain bugs to fix.
<br/>
You will find at the root of this github folder the user manuals and the EER diagrams.
<br/>Please note that, although OJS is available in multiple languages, the HRP has only its English language up to date.
<br/><br/>
<u>Requierements:</u>
<ul>
<li>PHP 5.3 or later with MySQL PostgreSQL support</li>
<li>A database server: MySQL 4.1 or later OR PostgreSQL 8.0 or later</li>
<li>UNIX-like OS recommended (such as Linux, FreeBSD, Solaris, Mac OS X, etc.).</li>
</ul>
<br/>
<u>Installation Steps:</u>
<br/>
<br/>
<ol>
<li>Create a new SQL database, encoded in "utf8_general_ci", and import the template database "template.sql" available at the root of the system.</li>
<li>Create at the root of the system a new config file "config.inc.php" based on the template file "config.TEMPLATE.inc.php" and configured according to your server. Please change the line 29 "installed = Off" to "installed = On". Instructions on how to configure this configuration file are provided inside. Please read them carefully. A particular attention should be made to the upload folder, referenced line 184. For security reasons, please create this one in a non-directly web-accessible part of your server and readable/writable only by your web-server (e.g. Apache).</li>
<li>Create the cache folder "cache" at the root of the system, and its subfolders "/cache/_db", '/cache/t_cache/', '/cache/t_compile/' and '/cache/t_config/'.</li>
<li>Create the png images of the banner and the footer (990 * 105 px) and place them in "/plugins/themes/hrp/images/".</li>
<li>Create the CSS file "/plugins/themes/hrp/hrp.css" based on the template "/plugins/themes/hrp/hrp.TEMPLATE.css".</li>
<li>Add the logo of the main institution that will be managing this Health Research Portal (e.g. logo of the Ministry of Health). This logo should be in the PNG format, smaller than 500*500 px, named "mainlogo.png", and located in "public/site/images/".</li>
<li>Similar to the "upload" directory (bullet point 2), you will then need to grant file permissions so that the web server can administer and write to the public/ and cache/ subdirectories of the OJS installation path and the config.inc.php configuration file. The specifics of setting permissions will depend on your web server configuration, i.e. whether PHP scripts run SetUID. For security reasons, please be careful on the permissions of all the files.</li>
<li>The system should now be accessible with the url you specified in your web-server. Please log-in with the administrator account, username "admin" and password "hrpadmin", and <u>change the administrator password</u> (instructions on how to change a user password are provided in the user manual).</li>
<li>With the administrator account, go to your "User Home" and click on the "administrator" link. You will arrive in the "Site Management" section. In order to run, the HRP needs at least 1 ethics committee with one secretary affiliated to it, the geographical areas, the research fields, the research domains, and the proposal types. Please be careful when entering these information; although some features allow you to modify these fields, once research proposals have been entered into the database, it becomes more complicated to manage these fields.</li>
<li>Customize the HRP by using the "Setup" link in the "Site Management" section. Please provide as much information as you can. More information on this can be found in the user-manual.</li>
</ol>
</p>

