{**
 * metadataEdit.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Form for changing metadata of an article (used in MetadataForm)
 *}

{strip}
{assign var="pageTitle" value="submission.editMetadata"}
{include file="common/header.tpl"}
{/strip}

{url|assign:"competingInterestGuidelinesUrl" page="information" op="competingInterestGuidelines"}

<form name="metadata" method="post" action="{url op="saveMetadata"}" enctype="multipart/form-data">
    <input type="hidden" name="articleId" value="{$articleId|escape}" />
    
    {include file="common/formErrors.tpl"}

    {include file="common/proposalSubmission/authors.tpl"}
    
    {include file="common/proposalSubmission/titleAndAbstracts.tpl"}

    {include file="common/proposalSubmission/proposalDetails.tpl"}

    {include file="common/proposalSubmission/sourcesOfMonetary.tpl"}
    
    {include file="common/proposalSubmission/riskAssessment.tpl"}

    <p><input type="submit" value="{translate key="submission.saveMetadata"}" class="button defaultButton"/> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="history.go(-1)" /></p>

    <p><span class="formRequired">{translate key="common.requiredField"}</span></p>
    <p><span class="formRequired">{translate key="common.mouseOver"}</span></p>
</form>

{include file="common/footer.tpl"}

{include file="common/proposalSubmission/javascript.tpl"}