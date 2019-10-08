
{strip}
{assign var=pageTitle value="search.summary"}
{include file="common/header.tpl"}
{/strip}

{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}

<br/>
<form name="revise" action="{url op="advanced"}" method="post">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<div style="display:none">
		{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
		{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	</div>
</form>

<form name="generate" action="{url op="generateCSV"}" method="post">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<div style="display:none">
		{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
		{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	</div>
</form>

<div id="downloadCompletionReport">
    {if $submission->getStatus() == STATUS_COMPLETED}
        {assign var="finalReport" value=$submission->getPublishedFinalReport()}
        <h3 align="right"><b><a href="{url op="downloadFinalReport" path=$submission->getArticleId()|to_array:$finalReport->getFileId()}" class="file">{translate key="search.downloadFinalReport"}</a></b></h3>
    {/if}
</div>
        
<div id="authors">
<h4>{translate key="article.authors"}</h4>
	
<table width="100%" class="data">
	{foreach name=authors from=$submission->getAuthors() item=author}
	<tr valign="top">
		<td width="20%" class="label">{if $author->getPrimaryContact()}{translate key="user.role.primaryInvestigator"}{else}{translate key="user.role.coinvestigator"}{/if}</td>
		<td width="80%" class="value">
                        <a href="{url op="authors" path="view"|to_array:$author->getId()}">{$author->getFullName()|escape}</a><br />
			{if $author->getAffiliation()}{$author->getAffiliation()|escape|nl2br|default:"&mdash;"}<br/>{/if}
			{assign var=emailString value=$author->getFullName()|concat:" <":$author->getEmail():">"}
			{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$abstract->getScientificTitle()|strip_tags articleId=$submission->getId()}
			{$author->getFullName()|escape} {icon name="mail" url=$url}
		</td>
	</tr>
	{/foreach}
</table>
</div>

<div id="titleAndAbstract">
	<h4><br/>{translate key="search.titlesAndAbstract"}</h4>

	<table width="100%" class="data">
		{if $submission->getStatus() == 11}
			<tr valign="top">
				<td class="label">&nbsp;</td>
				<td class="value">
				Completion Report:&nbsp;&nbsp;&nbsp;&nbsp;
				{foreach name="suppFiles" from=$suppFiles item=suppFile}
				{if $suppFile->getType() == "Completion Report"}<br/>
					<a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$suppFile->getFileId():$suppFile->getSuppFileId()}" class="file">{$suppFile->getFileName()|escape}</a>
				{/if}
				{foreachelse}
				Not available.
				{/foreach}
			</td>
			</tr>
		{/if}
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.scientificTitle"}</td>
        	<td class="value">{$abstract->getScientificTitle()}</td>
    	</tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.publicTitle"}</td>
        	<td class="value">{$abstract->getPublicTitle()}</td>
    	</tr>
    	<tr><td colspan="2">&nbsp;</td></tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.background"}</td>
        	<td class="value">{$abstract->getBackground()}</td>
    	</tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.objectives"}</td>
        	<td class="value">{$abstract->getObjectives()}</td>
    	</tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.studyMethods"}</td>
        	<td class="value">{$abstract->getStudyMethods()}</td>
    	</tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.expectedOutcomes"}</td>
        	<td class="value">{$abstract->getExpectedOutcomes()}</td>
    	</tr>
    	<tr><td colspan="2">&nbsp;</td></tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.keywords"}</td>
        	<td class="value">{$abstract->getKeywords()}</td>
    	</tr>
</table>
</div>

<div id="proposalDetails">
	<h4><br/>{translate key="search.researchDetails"}</h4>

	{assign var="proposalDetails" value=$submission->getProposalDetails()}
	
	<table class="listing" width="100%">
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.studentInitiatedResearch"}</td>
        	<td class="value">{translate key=$proposalDetails->getYesNoKey($proposalDetails->getStudentResearch())}</td>
    	</tr>
    	{if ($proposalDetails->getStudentResearch()) == PROPOSAL_DETAIL_YES}
			{assign var="studentResearch" value=$proposalDetails->getStudentResearchInfo()}
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{translate key="proposal.studentInstitution"}: {$studentResearch->getInstitution()}</td>
    		</tr>
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{translate key="proposal.academicDegree"}: {translate key=$studentResearch->getDegreeKey()}</td>
    		</tr>
        	<tr valign="top" id="supervisor"><td class="label" width="20%">&nbsp;</td><td class="value"><b>{translate key="proposal.studentSupervisor"}</b></td></tr>
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{translate key="proposal.studentSupervisorName"}: {$studentResearch->getSupervisorName()}</td>
    		</tr>
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{translate key="user.email"}: {$studentResearch->getSupervisorEmail()}</td>
    		</tr>
        	<tr valign="top"><td class="label" width="20%">&nbsp;</td><td class="value">&nbsp;</td></tr>
    	{/if}
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.startDate"}</td>
        	<td class="value">{$proposalDetails->getStartDate()}</td>
   	 	</tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.endDate"}</td>
        	<td class="value">{$proposalDetails->getEndDate()}</td>
    	</tr>
        <tr valign="top">
            <td class="label" width="20%">{translate key="proposal.keyImplInstitution"}</td>
            <td class="value">{$proposalDetails->getKeyImplInstitutionName()}</td>
        </tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.multiCountryResearch"}</td>
        	<td class="value">{translate key=$proposalDetails->getYesNoKey($proposalDetails->getMultiCountryResearch())}</td>
    	</tr>
	{if ($proposalDetails->getMultiCountryResearch()) == PROPOSAL_DETAIL_YES}
		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{$proposalDetails->getLocalizedMultiCountryText()}</td>
    		</tr>
    	{/if}
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.nationwide"}</td>
        	<td class="value">{translate key=$proposalDetails->getNationwideKey()}</td>
   	 	</tr>
    	{if $proposalDetails->getNationwide() == PROPOSAL_DETAIL_NO || $proposalDetails->getNationwide() == PROPOSAL_DETAIL_YES_WITH_RANDOM_AREAS}
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{$proposalDetails->getLocalizedGeoAreasText()}</td>
    		</tr>
        {/if}
        <tr valign="top">
                <td class="label" width="20%">{translate key="proposal.researchDomains"}</td>
                <td class="value">{$proposalDetails->getLocalizedResearchDomainsText()}</td>
        </tr>	    	
        <tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.researchField"}</td>
        	<td class="value">{$proposalDetails->getLocalizedResearchFieldText()}</td>
    	</tr>
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.withHumanSubjects"}</td>
        	<td class="value">{translate key=$proposalDetails->getYesNoKey($proposalDetails->getHumanSubjects())}</td>
    	</tr>
    	{if ($proposalDetails->getHumanSubjects()) == PROPOSAL_DETAIL_YES}
    		<tr valign="top">
        		<td class="label" width="20%">&nbsp;</td>
        		<td class="value">{$proposalDetails->getLocalizedProposalTypeText()}</td>
   			</tr>
    	{/if}
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.dataCollection"}</td>
        	<td class="value">{translate key=$proposalDetails->getDataCollectionKey()}</td>
    	</tr>   
    	<tr valign="top">
        	<td class="label" width="20%">{translate key="proposal.reviewedByOtherErc"}</td>
        	<td class="value">{translate key=$proposalDetails->getCommitteeReviewedKey()}</td>
    	</tr>
	</table>
</div>

{include file="common/footer.tpl"}

