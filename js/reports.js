/* 
 * JS file containing all the functions used during the generation or reports
 */

function showOrHideDecisionTable(){
   var value = $('#decisionTableShow').val();
   if (value === "0") {
       $('#decisionTable').show();
       $('#decisionTableShow').val("1");
   } else {
       $('#decisionTable').hide();
       $('#decisionTableShow').val("0");       
       $('#decisionCommittee').val("0");
       $('#decisionType').val(INITIAL_REVIEW);
       $('#decisionStatus').val(SUBMISSION_SECTION_DECISION_APPROVED);
       $('#decisionAfter').val("");
       $("#decisionAfter").datepicker("option","maxDate", '-1 d');
       $('#decisionBefore').val("");
       $("#decisionBefore").datepicker("option","minDate", null);
   }
}

// The decision date "after" can not be after the decision date "before"
function changeDecisionBeforeDate(){
    dayAfter = new Date();
    dayAfter = $("#decisionAfter").datepicker("getDate");
    dayAfter.setDate(dayAfter.getDate() + 1);
    $("#decisionBefore").datepicker("option","minDate", dayAfter);
} 
function changeDecisionAfterDate(){
    dayBefore = new Date();
    dayBefore = $("#decisionBefore").datepicker("getDate");
    dayBefore.setDate(dayBefore.getDate() - 1);
    $("#decisionAfter").datepicker("option","maxDate", dayBefore);
} 

function showOrHideDetailsTable(){
   var value = $('#detailsTableShow').val();
   if (value === "0") {
       $('#detailsTable').show();
       $('#detailsTableShow').val("1");
   } else {
       $('#detailsTable').hide();
       $('#detailsTableShow').val("0");   
       $('#filterBy input:radio[name="studentInitiatedResearch"]').attr('checked', false);       
       $('#startAfter').val("");   
       $("#startAfter").datepicker("option","minDate", null);
       $("#startAfter").datepicker("option","maxDate", null);       
       $('#startBefore').val("");  
       $("#startBefore").datepicker("option","minDate", null);
       $("#startBefore").datepicker("option","maxDate", null);
       $('#endAfter').val("");   
       $("#endAfter").datepicker("option","minDate", null);
       $("#endAfter").datepicker("option","maxDate", null);
       $('#endBefore').val("");   
       $("#endBefore").datepicker("option","minDate", null);
       $("#endBefore").datepicker("option","maxDate", null);
       $('#firstKII').find('select').val("");   
       $('#filterBy tr.KIISupp').remove();
       $('#filterBy input:radio[name="multiCountryResearch"]').attr('checked', false);
       showOrHideCountryFields();       
       $('#firstGeoArea').find('select').val("");   
       $('#filterBy tr.geoAreaSupp').remove();    
       $('#firstResearchDomain').find('select').val("");   
       $('#filterBy tr.researchDomainSupp').remove();        
       $('#firstResearchField').find('select').val("");   
       $('#filterBy tr.researchFieldSupp').remove();        
       $('#filterBy input:radio[name="withHumanSubjects"]').attr('checked', false);
       showOrHideProposalTypes();       
       $('#dataCollection').val("");   
   }
}

// Manage the minimal and maximal dates of the research dates field 
function researchStartAfterChanged(){
    startAfter = new Date();
    startAfter = $("#startAfter").datepicker("getDate");
    $("#startBefore").datepicker("option","minDate", startAfter);
    $("#endAfter").datepicker("option","minDate", startAfter);
    $("#endBefore").datepicker("option","minDate", startAfter);
}
function researchStartBeforeChanged(){
    startBefore = new Date();
    startBefore = $("#startBefore").datepicker("getDate");
    $("#startAfter").datepicker("option","maxDate", startBefore);
    $("#endAfter").datepicker("option","minDate", startBefore);
    $("#endBefore").datepicker("option","minDate", startBefore);
}
function researchEndAfterChanged(){
    endAfter = new Date();
    endAfter = $("#endAfter").datepicker("getDate");
    $("#startAfter").datepicker("option","maxDate", endAfter);
    $("#startBefore").datepicker("option","maxDate", endAfter);
    $("#endBefore").datepicker("option","minDate", endAfter);
}
function researchEndBeforeChanged(){
    endBefore = new Date();
    endBefore = $("#endBefore").datepicker("getDate");
    $("#startAfter").datepicker("option","maxDate", endBefore);
    $("#startBefore").datepicker("option","maxDate", endBefore);
    $("#endAfter").datepicker("option","maxDate", endBefore);
}

function addKII(){
    var KIIHtml = '<tr valign="top" class="KIISupp">' + $('#firstKII').html() + '</tr>';
    
    if ($("#filterBy tr.KIISupp")[0]){
        $('#filterBy tr.KIISupp:last').after(KIIHtml);
        var lastElement = $('#filterBy tr.KIISupp:last');
    } else {
        $('#firstKII').after(KIIHtml);
        var lastElement = $('#firstKII').next();
    }    
    lastElement.find('select').attr('selectedIndex', 0);
    lastElement.find('.KIITitle').html(OR_STRING+'&nbsp;&nbsp;');
    lastElement.find('.KIITitle').attr('align','right');
    lastElement.find('.removeKII').show();
    lastElement.find('.removeKII').click(function(){$(this).closest('tr').remove();});    
}

function addCountry(){
    var countryHtml = '<tr valign="top" class="countrySupp">' + $('#firstCountry').html() + '</tr>';
    if ($("#filterBy tr.countrySupp")[0]){
        $('#filterBy tr.countrySupp:last').after(countryHtml);
        var lastElement = $('#filterBy tr.countrySupp:last');
    } else {
        $('#firstCountry').after(countryHtml);
        var lastElement = $('#firstCountry').next();
    }    
    lastElement.find('select').attr('selectedIndex', 0);
    lastElement.find('.countryTitle').html(OR_STRING+'&nbsp;&nbsp;');
    lastElement.find('.countryTitle').attr('align','right');
    lastElement.find('.removeCountry').show();
    lastElement.find('.removeCountry').click(function(){$(this).closest('tr').remove();});    
}

function showOrHideCountryFields(){
   var value = $('#filterBy input:radio[name="multiCountryResearch"]:checked').val();
   if (value === PROPOSAL_DETAIL_YES) {
       $('#firstCountry').show();
       $('#addAnotherCountry').show();       
   } else {
       $('#firstCountry').hide();
       $('#firstCountry').find('select').val("");   
       $('#filterBy tr.countrySupp').remove();
       $('#addAnotherCountry').hide();   
   }
}

function addGeoArea(){
    var areaHtml = '<tr valign="top" class="geoAreaSupp">' + $('#firstGeoArea').html() + '</tr>';
    if ($("#filterBy tr.geoAreaSupp")[0]){
        $('#filterBy tr.geoAreaSupp:last').after(areaHtml);
        var lastElement = $('#filterBy tr.geoAreaSupp:last');
    } else {
        $('#firstGeoArea').after(areaHtml);
        var lastElement = $('#firstGeoArea').next();
    }    
    lastElement.find('select').attr('selectedIndex', 0);
    lastElement.find('.geoAreaTitle').html(OR_STRING+'&nbsp;&nbsp;');
    lastElement.find('.geoAreaTitle').attr('align','right');
    lastElement.find('.removeGeoArea').show();
    lastElement.find('.removeGeoArea').click(function(){$(this).closest('tr').remove();});    
}

function addResearchDomain(){
    var rDomainHtml = '<tr valign="top" class="researchDomainSupp">' + $('#firstResearchDomain').html() + '</tr>';
    if ($("#filterBy tr.researchDomainSupp")[0]){
        $('#filterBy tr.researchDomainSupp:last').after(rDomainHtml);
        var lastElement = $('#filterBy tr.researchDomainSupp:last');
    } else {
        $('#firstResearchDomain').after(rDomainHtml);
        var lastElement = $('#firstResearchDomain').next();
    }    
    lastElement.find('select').attr('selectedIndex', 0);
    lastElement.find('.researchDomainTitle').html(OR_STRING+'&nbsp;&nbsp;');
    lastElement.find('.researchDomainTitle').attr('align','right');
    lastElement.find('.removeResearchDomain').show();
    lastElement.find('.removeResearchDomain').click(function(){$(this).closest('tr').remove();}); 
}


function addResearchField(){
    var rFieldHtml = '<tr valign="top" class="researchFieldSupp">' + $('#firstResearchField').html() + '</tr>';
    if ($("#filterBy tr.researchFieldSupp")[0]){
        $('#filterBy tr.researchFieldSupp:last').after(rFieldHtml);
        var lastElement = $('#filterBy tr.researchFieldSupp:last');
    } else {
        $('#firstResearchField').after(rFieldHtml);
        var lastElement = $('#firstResearchField').next();
    }    
    lastElement.find('select').attr('selectedIndex', 0);
    lastElement.find('.researchFieldTitle').html(OR_STRING+'&nbsp;&nbsp;');
    lastElement.find('.researchFieldTitle').attr('align','right');
    lastElement.find('.removeResearchField').show();
    lastElement.find('.removeResearchField').click(function(){$(this).closest('tr').remove();}); 
}

function showOrHideProposalTypes(){
   var value = $('#filterBy input:radio[name="withHumanSubjects"]:checked').val();
   if (value === PROPOSAL_DETAIL_YES) {
       $('#firstProposalType').show();
       $('#addAnotherType').show();       
   } else {
       $('#firstProposalType').hide();
       $('#firstProposalType').find('select').val("");   
       $('#filterBy tr.proposalTypeSupp').remove();
       $('#addAnotherType').hide();   
   }
}

function addProposalType(){
    var proposalTypeHtml = '<tr valign="top" class="proposalTypeSupp">' + $('#firstProposalType').html() + '</tr>';
    if ($("#filterBy tr.proposalTypeSupp")[0]){
        $('#filterBy tr.proposalTypeSupp:last').after(proposalTypeHtml);
        var lastElement = $('#filterBy tr.proposalTypeSupp:last');
    } else {
        $('#firstProposalType').after(proposalTypeHtml);
        var lastElement = $('#firstProposalType').next();
    }    
    lastElement.find('select').attr('selectedIndex', 0);
    lastElement.find('.proposalTypeTitle').html(OR_STRING+'&nbsp;&nbsp;');
    lastElement.find('.proposalTypeTitle').attr('align','right');
    lastElement.find('.removeType').show();
    lastElement.find('.removeType').click(function(){$(this).closest('tr').remove();}); 
}

function showOrHideSourcesTable(){
   var value = $('#sourcesTableShow').val();
   if (value === "0") {
       $('#sourcesTable').show();
       $('#sourcesTableShow').val("1");
   } else {
       $('#sourcesTable').hide();
       $('#sourcesTableShow').val("0");
       $('#budget').val("");       
       $('#firstSource').find('select').val("");   
       $('#sourcesTable tr.sourceSupp').remove();
   }
}

function isNumeric(){
    var numericExpression = /^([\s]*[0-9]+[\s]*)+$/;
    var value = $('#budget').val();
        if (value.match(numericExpression)){
            displayTotalBudget();
            return true;
        } else {
            alert(SOURCE_AMOUNT_NUMERIC);
            $(this).focus();
            return false;
        }   
}

function addSource(){
    var sourceHtml = '<tr valign="top" class="sourceSupp">' + $('#firstSource').html() + '</tr>';
    
    if ($("#sourcesTable tr.sourceSupp")[0]){
        $('#sourcesTable tr.sourceSupp:last').after(sourceHtml);
        var lastElement = $('#sourcesTable tr.sourceSupp:last');
    } else {
        $('#firstSource').after(sourceHtml);
        var lastElement = $('#firstSource').next();
    }    
    lastElement.find('select').attr('selectedIndex', 0);
    lastElement.find('.sourceTitle').html(OR_STRING+'&nbsp;&nbsp;');
    lastElement.find('.sourceTitle').attr('align','right');
    lastElement.find('.removeSource').show();
    lastElement.find('.removeSource').click(function(){$(this).closest('tr').remove();});    
}

function showOrHideRiskAssessmentTable(){
   var value = $('#riskAssessmentTableShow').val();
   if (value === "0") {
       $('#riskAssessmentTable').show();
       $('#riskAssessmentTableShow').val("1");
   } else {
       $('#riskAssessmentTable').hide();
       $('#riskAssessmentTableShow').val("0");
       $('#riskAssessmentTable input.riskAssessmentRadio').attr('checked', false); 
       showOrHideExportHumanTissue();
   }
}

function showOrHideExportHumanTissue(){
    var value = $("#riskAssessmentTable input:radio[name='bioSamples']:checked").val();
    if (value === RISK_ASSESSMENT_NO || typeof value === "undefined") {
         $('#exportHumanTissueField').hide();
         if(!$('#hiddenExportHumanTissueRadio').length){
            $('#exportHumanTissueField').append($('<input type="radio" name="exportHumanTissue" id="hiddenExportHumanTissueRadio" value="NA">'));
         }
         $('#hiddenExportHumanTissueRadio').attr('checked', 'checked');
    } else {
         $('#exportHumanTissueField').show();
         $('#hiddenExportHumanTissueRadio').remove();
    }
    showOrHideExportReason();
}

function showOrHideExportReason(){
    var value = $("#riskAssessmentTable input:radio[name='exportHumanTissue']:checked").val();
    if (value === RISK_ASSESSMENT_NO || value === 'NA' || typeof value === "undefined") {
         $('#exportReasonField').hide();
         if($('#exportReasonSelect option[value="NA"]').length === 0){ // check if select option exists
            $('#exportReasonSelect').append($('<option value="NA"></option>'));
         }
         $('#exportReasonSelect').val('NA');         
    } else {
         $('#exportReasonField').show();
         if($('#exportReasonSelect option[value="NA"]').length > 0){ // check if select option exists
            $('#exportReasonSelect option[value="NA"]').remove();
         }
         
    }
}

function showSelectedReportType(){
   var value = $('#reportType').val();
   if (value === "0") {
       $('#defaultButton').show();   
       $('#spreadsheetTable').show();
       $('#pieChartTable').hide();       
   } else if (value === "1") {
       $('#defaultButton').show();       
       $('#spreadsheetTable').hide();
       $('#pieChartTable').show();       
   } else if (value === "2") {
       $('#defaultButton').show();       
       $('#spreadsheetTable').hide();
       $('#pieChartTable').show();       
   } else {
       $('#defaultButton').hide();       
       $('#spreadsheetTable').hide();
       $('#pieChartTable').hide();       
   }
}