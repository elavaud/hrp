{**
 * javascript.tpl
 *
 * This file is used for incorporating all the javascript and jquery functions used during of the Step 2 of author article submission.
 * The javascript use some smarty variables. It's why it is currently in a tpl file.
 *
 * FIX ME: Finding a workaround for including the smarty variable into a real js file, but moreover reorganizing this file in order to use a modern way to call events.
 *
 *}
 
 <script type="text/javascript" src="{$baseUrl|cat:"/js/proposalSubmission.js"}"></script>

 {literal}
     <script type="text/javascript">

    
       var PROPOSAL_DETAIL_NO = "{/literal}{$smarty.const.PROPOSAL_DETAIL_NO}{literal}";
       var PROPOSAL_DETAIL_YES = "{/literal}{$smarty.const.PROPOSAL_DETAIL_YES}{literal}";
       
       var INSTITUTION_NATIONAL = "{/literal}{$smarty.const.INSTITUTION_NATIONAL}{literal}";
       var INSTITUTION_INTERNATIONAL = "{/literal}{$smarty.const.INSTITUTION_INTERNATIONAL}{literal}";       
       
       var PROPOSAL_DETAIL_YES_WITH_RANDOM_AREAS = "{/literal}{$smarty.const.PROPOSAL_DETAIL_YES_WITH_RANDOM_AREAS}{literal}";
       
       var PROPOSAL_DETAIL_UNDER_REVIEW = "{/literal}{$smarty.const.PROPOSAL_DETAIL_UNDER_REVIEW}{literal}";
       var PROPOSAL_DETAIL_REVIEW_AVAILABLE = "{/literal}{$smarty.const.PROPOSAL_DETAIL_REVIEW_AVAILABLE}{literal}";
       
       var SOURCE_AMOUNT_NUMERIC = "{/literal}{translate key="proposal.source.amount.instruct"}{literal}";
       
       var RISK_ASSESSMENT_NO = "{/literal}{$smarty.const.RISK_ASSESSMENT_NO}{literal}";
       var RISK_ASSESSMENT_YES = "{/literal}{$smarty.const.RISK_ASSESSMENT_YES}{literal}";
       var RISK_ASSESSMENT_NOT_PROVIDED = "{/literal}{$smarty.const.RISK_ASSESSMENT_NOT_PROVIDED}{literal}";

       var RISK_ASSESSMENT_NO_LAB_CAPACITY = "{/literal}{$smarty.const.RISK_ASSESSMENT_NO_LAB_CAPACITY}{literal}";
       var RISK_ASSESSMENT_REQUIRE_QUALITY_ASSURANCE = "{/literal}{$smarty.const.RISK_ASSESSMENT_REQUIRE_QUALITY_ASSURANCE}{literal}";

       var RISK_ASSESSMENT_NO_MORE_THAN_MINIMAL = "{/literal}{$smarty.const.RISK_ASSESSMENT_NO_MORE_THAN_MINIMAL}{literal}";
       var RISK_ASSESSMENT_MINORE_THAN_MINIMAL = "{/literal}{$smarty.const.RISK_ASSESSMENT_MINORE_THAN_MINIMAL}{literal}";
       var RISK_ASSESSMENT_MORE_THAN_MINIMAL = "{/literal}{$smarty.const.RISK_ASSESSMENT_MORE_THAN_MINIMAL}{literal}";

       var RISK_ASSESSMENT_CONFLICT_OF_INTEREST_YES = "{/literal}{$smarty.const.RISK_ASSESSMENT_CONFLICT_OF_INTEREST_YES}{literal}";
       var RISK_ASSESSMENT_CONFLICT_OF_INTEREST_NO = "{/literal}{$smarty.const.RISK_ASSESSMENT_CONFLICT_OF_INTEREST_NO}{literal}";
       var RISK_ASSESSMENT_CONFLICT_OF_INTEREST_NOT_SURE = "{/literal}{$smarty.const.RISK_ASSESSMENT_CONFLICT_OF_INTEREST_NOT_SURE}{literal}";

             
        ///////////
        // Events:
        ///////////
        
        $("[name='proposalDetails[studentInitiatedResearch]']").change(showOrHideStudentInfo);
        
        //Date picker + restrict end date to (start date) + 1
        $( "#startDate" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-1 y', onSelect: function(dateText, inst){dayAfter = new Date();dayAfter = $("#startDate").datepicker("getDate");dayAfter.setDate(dayAfter.getDate() + 1);$("#endDate").datepicker("option","minDate", dayAfter);}});
        $( "#endDate" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-1 y'});
        
        $("#keyImplInstitution").change(showOrHideOherKeyImplementingInstitutionField);
        
        $("[name='proposalDetails[international]']").change(showLocationKII);
        
        $("[name='proposalDetails[multiCountryResearch]']").change(showOrHideMultiCountryResearch);
        
        $("#addAnotherCountryClick").click(addCountry);
        
        $('#proposalDetails a.removeMultiCountry').each(function() {$(this).click(function(){$(this).closest('tr').remove();});});
        
        $("[name='proposalDetails[nationwide]']").change(showOrHideGeoAreas);
        
        $("#addAnotherAreaClick").click(addGeoArea);
        
        $('#proposalDetails a.removeProposalProvince').each(function() {$(this).click(function(){$(this).closest('tr').remove();});});        
        
        $("#addAnotherDomainClick").click(addResearchDomain);
        
        $('#proposalDetails a.removeResearchDomain').each(function() {$(this).click(function(){$(this).closest('tr').remove();});});        

        $('[name^=proposalDetails[researchFields]]').each(function() {$(this).change(showOrHideOtherResearchField);});
        
        $("#addAnotherFieldClick").click(addResearchField);
        
        $('#proposalDetails a.removeResearchField').each(function() {$(this).click(function(){$(this).closest('tr').remove();});});        
        
        $("[name='proposalDetails[withHumanSubjects]']").change(showOrHideProposalTypes);
        
        $('[name^=proposalDetails[proposalTypes]]').each(function() {$(this).change(showOrHideOtherProposalType);});
        
        $("#addAnotherTypeClick").click(addProposalType);
        
        $('#proposalDetails a.removeProposalType').each(function() {$(this).click(function(){$(this).closest('tr').remove();});});        
        
        $("[name='proposalDetails[reviewedByOtherErc]']").change(showOrHideOtherErcDecision);
                
        $("#sources select[id$=-institution]").each(function() {$(this).change(showOrHideOtherSource);});
        
        $("#sources").find("input:radio").each(function() {$(this).change(showLocationOtherSource);});
    
        $("#sources input[id$=-amount]").each(function() {$(this).keyup(isNumeric);});
        
        $("#addAnotherSource").click(addSource);
        
        $('#sources a.removeSource').each(function() {$(this).click(function(){$(this).closest('table').remove();displayTotalBudget();});});                
        
        $("[name='riskAssessment[bioSamples]']").change(showOrHideExportHumanTissue);

        $("[name='riskAssessment[exportHumanTissue]']").change(showOrHideExportReason);

        $("#riskLevel").change(showOrHideOtherLevelOfRisk);
       
        $(document).ready(
            function() {
                
                showOrHideStudentInfo();
                                
                showOrHideOherKeyImplementingInstitutionField();
                
                showLocationKII();
                
                showOrHideMultiCountryResearch();
                
                showOrHideGeoAreas();
                
                showOrHideOtherResearchField();
                
                showOrHideProposalTypes();
                
                showOrHideOtherProposalType();
                
                showOrHideOtherErcDecision();
                                
                displayTotalBudget();
                
                showOrHideOtherSource();
                                
                showOrHideExportHumanTissue();
                
                showOrHideOtherLevelOfRisk();
            }
        );  
     </script>
 {/literal}