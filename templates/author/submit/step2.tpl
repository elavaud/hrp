{**
 * step2.tpl
 *
 * Step 2 of author article submission.
 *
 * $Id$
 *}
{assign var="pageTitle" value="author.submit.step2"}
{include file="author/submit/submitHeader.tpl"}

{url|assign:"competingInterestGuidelinesUrl" page="information" op="competingInterestGuidelines"}

<div class="separator"></div>

<form name="submit" method="post" action="{url op="saveSubmit" path=$submitStep}">
    <input type="hidden" name="articleId" value="{$articleId|escape}" />
    {include file="common/formErrors.tpl"}

    {include file="common/proposalSubmission/authors.tpl"}
    
    {include file="common/proposalSubmission/titleAndAbstracts.tpl"}

    {include file="common/proposalSubmission/proposalDetails.tpl"}

    {include file="common/proposalSubmission/sourcesOfMonetary.tpl"}
    
    {include file="common/proposalSubmission/riskAssessment.tpl"}
    
    <p><input type="submit" value="{translate key="common.saveAndContinue"}" class="button defaultButton"/> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="confirmAction('{url page="author"}', '{translate|escape:"jsparam" key="author.submit.cancelSubmission"}')" /></p>

</form>

{include file="common/footer.tpl"}

{include file="common/proposalSubmission/javascript.tpl"}