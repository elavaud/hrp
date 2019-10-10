# The Health Research Portal &nbsp;

## Introduction &nbsp;

The Health Research Portal (HRP) is an ***integrated online health research management system*** that offers substantial benefits for all stakeholders in health research. The Portal aims to improve accountability, efficiency and quality of health research conducted in country by providing information on all ongoing research and hence increasing transparency and by streamlining the review process. &nbsp;

The Portal can be used to:
* **Submit research proposals** for review to one of the ethics committee of the country, 24x7, from anywhere. Researchers need to register on the Portal. Once registered, the user will have a permanent account and be able to submit research proposal in a paper-less way and to track the review status of his/her proposals.
* **Search ongoing and completed health research** from the launch of the system onwards through a publicly accessible research registry. No registration or log-in is required.
* **Access complete research reports** for the researches started since the launch, once the research is completed.
* **Access information on all the applicable guidelines, rules, and regulations** related to health research.
* **Access a “Researchers' Directory”** containing information on the national and international researchers doing research in the country.
* **Obtain statistics on health research in the country** using the metadata of the researches registered (restricted access).&nbsp;


## Features &nbsp;

Below are the main features that the Health Research Portal possesses. For a deeper understanding of the system, we recommend you to try it or to take a look to the user manuals included in the source code above.&nbsp;

* Different user roles (investigator, ethics committee member, coordinator of health research in the country/region...) with restricted access.
* Management of multiple ethics committees with respect of the confidentiality.
* Submission / Re-submission / Amendment / Adverse-event of a health research.
* Organized storage of the research documents with restricted access.
* Custom generation of data sets (CSV) or charts using the metadata entered for each research proposal.
* Generation of approval notices, customizable for each committee.
* Generation of customizable PDF cover and disclaimer for the completion reports.
* Management of the funding agencies, research fields / domains, proposal types and geographical areas.
* Management of the content of the publicly accessible part of the system.&nbsp;

## Installation &nbsp;

The Health Research Portal is based on  the Open Journal System (OJS) v. 2.3.4 of the Public Knowledge Project. Numerous references to OJS are still disseminated throughout the HRP. If you cannot find the information you are looking for into the manuals, we would recommend you to take a look to the  [PKP-OJS website](https://pkp.sfu.ca/ojs/). The HRP might still contain bugs to fix. &nbsp;

You will find at the root of this github folder the user manuals and the EER diagrams. &nbsp;

Please note that, although OJS is available in multiple languages, the HRP has only its English language up to date.&nbsp;

### Requierements: &nbsp;
* Docker, tested with v19.03.2
* Docker-compose, tested with v1.24.1 
* Git, test with 2.20.1 &nbsp;

### Installation Steps: &nbsp;

1. Clone the current repository in your server
2. Create the environment file (.env) in the docker folder, based on the template (.env.example)
3. Replace the png images of the demo banner and footer by your own (990 * 105 px, located in plugins/themes/hrp/images), as well as the main logo of your organisation (max 500*500 px, located in public/site/images/mainlogo.png)
4. Launch the docker compose from the root of the project referencing its yml file (`docker-compose -f docker/docker-compose.yml up -d`). Once the images downloaded and built, the HRP should be available on port 80. You can log in with the adminstrator account (user: admin, pwd: hrpadmin)
5. Customize the HRP, that is: change the administrator password, go to site management section and provide as much information as available (at least one ethics committee with one secretary affiliated to it should exist), customize the css file created in plugins/themes/hrp/hrp.TEMPLATE.css.
