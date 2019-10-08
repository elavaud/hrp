/* 
 * JS file containing all the functions used during the submission or the edition of article
 */

function showOrHideStudentInfo(){
   var value = $("input:radio[name='proposalDetails[studentInitiatedResearch]']:checked").val();
   if (value === PROPOSAL_DETAIL_NO || typeof value === "undefined") {
        $('#studentInfo').hide();
        $('#studentInstitution').val("NA");
        if (!$('#academicDegree option[value="9"]').length > 0){
            $('#academicDegree').append('<option value="9"></option>');
        }
        $('#academicDegree').val("9");
        $('#supervisorName').val("NA");
        $('#supervisorEmail').val("NA");
   } else {
        $('#studentInfo').show();               
        if($('#studentInstitution').val() === "NA") {
            $('#studentInstitution').val("");
        }
        if ($('#academicDegree option[value="9"]').length > 0){
            $('#academicDegree option[value="9"]').remove();
        }
        if($('#supervisorName').val() === "NA") {
            $('#supervisorName').val("");
        }
        if($('#supervisorEmail').val() === "NA") {
            $('#supervisorEmail').val("");
        }
   }
}

function showOrHideOherKeyImplementingInstitutionField(){
    var value = $("#keyImplInstitution").val();
    if (value === 'OTHER') {
        $('#otherInstitution').show();
        if($('#otherInstitutionName').val() === "NA") {
            $('#otherInstitutionName').val("");
        }
        if($('#otherInstitutionAcronym').val() === "NA") {
            $('#otherInstitutionAcronym').val("");
        }
        if ($('#otherInstitutionType option[value="9999"]').length > 0){
            $('#otherInstitutionType option[value="9999"]').remove();
        }
        if ($("#radioInternationalSupp").length) {
            $('#radioInternationalSupp').remove();
        }
    } else {
        $('#otherInstitution').hide();
        $('#otherInstitutionName').val("NA");
        $('#otherInstitutionAcronym').val("NA");
        if (!$('#otherInstitutionType option[value="9999"]').length > 0){
            $('#otherInstitutionType').append('<option value="9999"></option>');
        }
        $('#otherInstitutionType').val("9999");
        if (!$("#radioInternationalSupp").length) {
            $('input[name$="proposalDetails[international]"]:last').closest('label').after($('<label><input type="radio" name="proposalDetails[international]" id="radioInternationalSupp" value="NA"></label>'));        
        }
        $('#radioInternationalSupp').attr('checked', 'checked');     
    }
    showLocationKII();
}

function showLocationKII() {
    var value = $("input:radio[name='proposalDetails[international]']:checked").val();
    if (value === INSTITUTION_NATIONAL) {
        $('#locationCountryRow').show();
        if ($('#locationCountry option[value="0"]').length > 0){
            $('#locationCountry option[value="0"]').remove();
        }                
        $('#locationInternationalRow').hide();
        if (!$('#locationInternational option[value="0"]').length > 0){
            $('#locationInternational').append('<option value="0"></option>');
        }
        $('#locationInternational').val("0");                
    } else if (value === INSTITUTION_INTERNATIONAL) {
        $('#locationCountryRow').hide();
        if (!$('#locationCountry option[value="0"]').length > 0){
            $('#locationCountry').append('<option value="0"></option>');
        }
        $('#locationCountry').val("0");                   
        $('#locationInternationalRow').show();
        if ($('#locationInternational option[value="0"]').length > 0){
            $('#locationInternational option[value="0"]').remove();
        }                  
    } else {
        $('#locationCountryRow').hide();
        if (!$('#locationCountry option[value="0"]').length > 0){
            $('#locationCountry').append('<option value="0"></option>');
        }
        $('#locationCountry').val("0");                 

        $('#locationInternationalRow').hide();
        if (!$('#locationInternational option[value="0"]').length > 0){
            $('#locationInternational').append('<option value="0"></option>');
        }
        $('#locationInternational').val("0");                 
    }
}


function showOrHideMultiCountryResearch(){
    var value = $("input:radio[name='proposalDetails[multiCountryResearch]']:checked").val();
    if (value === PROPOSAL_DETAIL_NO || typeof value === "undefined") {
         $('#firstMultiCountry').hide();
         $('#addAnotherCountry').hide();
         $("#proposalDetails tr.multiCountrySupp").remove();
         if (!$('#multiCountry option[value="MCNA"]').length > 0){
             $('#multiCountry').append('<option value="MCNA"></option>');
         }
         $('#multiCountry').val("MCNA");
    } else {
         $('#firstMultiCountry').show();
         $('#addAnotherCountry').show();
         if ($('#multiCountry option[value="MCNA"]').length > 0){
             $('#multiCountry option[value="MCNA"]').remove();
         }
    }
}

function addCountry(){
    var multiCountryHtml = '<tr valign="top" class="multiCountrySupp">' + $('#firstMultiCountry').html() + '</tr>';
    if ($("#proposalDetails tr.multiCountrySupp")[0]){
        $('#proposalDetails tr.multiCountrySupp:last').after(multiCountryHtml);
        $('#proposalDetails tr.multiCountrySupp:last').find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.multiCountrySupp:last').find('.removeMultiCountry').show();
        $('#proposalDetails tr.multiCountrySupp:last').find('.removeMultiCountry').click(function(){$(this).closest('tr').remove();});
    } else {
        $('#firstMultiCountry').after(multiCountryHtml);
        $('#firstMultiCountry').next().find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.multiCountrySupp').find('.removeMultiCountry').show();
        $('#proposalDetails tr.multiCountrySupp').find('.removeMultiCountry').click(function(){$(this).closest('tr').remove();});
    }
}

function showOrHideGeoAreas(){
    var value = $("input:radio[name='proposalDetails[nationwide]']:checked").val();
    if (value === PROPOSAL_DETAIL_YES || typeof value === "undefined") {
         $('#firstGeoArea').hide();
         $('#addAnotherArea').hide();
         $("#proposalDetails tr.geoAreaSupp").remove();
         if (!$('#geoArea option[value="NW"]').length > 0){
             $('#geoArea').append('<option value="NW"></option>');
         }
         $('#geoArea').val("NW");
    } else {
         $('#firstGeoArea').show();
         $('#addAnotherArea').show();
         if ($('#geoArea option[value="NW"]').length > 0){
             $('#geoArea option[value="NW"]').remove();
         }
    }
}    

function addGeoArea(){
    var geoAreaHtml = '<tr valign="top" class="geoAreaSupp">' + $('#firstGeoArea').html() + '</tr>';
    if ($("#proposalDetails tr.geoAreaSupp")[0]){
        $('#proposalDetails tr.geoAreaSupp:last').after(geoAreaHtml);
        $('#proposalDetails tr.geoAreaSupp:last').find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.geoAreaSupp:last').find('.removeProposalProvince').show();
        $('#proposalDetails tr.geoAreaSupp:last').find('.removeProposalProvince').click(function(){$(this).closest('tr').remove();});
    } else {
        $('#firstGeoArea').after(geoAreaHtml);
        $('#firstGeoArea').next().find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.geoAreaSupp').find('.removeProposalProvince').show();
        $('#proposalDetails tr.geoAreaSupp').find('.removeProposalProvince').click(function(){$(this).closest('tr').remove();});
    }            
} 

function addResearchDomain(){
    var researchDomainHtml = '<tr valign="top" class="researchDomainSupp">' + $('#firstResearchDomain').html() + '</tr>';
    if ($("#proposalDetails tr.researchDomainSupp")[0]){
        $('#proposalDetails tr.researchDomainSupp:last').after(researchDomainHtml);
        $('#proposalDetails tr.researchDomainSupp:last').find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.researchDomainSupp:last').find('.removeResearchDomain').show();
        $('#proposalDetails tr.researchDomainSupp:last').find('.removeResearchDomain').click(function(){$(this).closest('tr').remove();});
        $('#proposalDetails tr.researchDomainSupp:last').find('.researchDomainTitle').hide();
        $('#proposalDetails tr.researchDomainSupp:last').find('.noResearchDomainTitle').show();
    } else {
        $('#firstResearchDomain').after(researchDomainHtml);
        $('#firstResearchDomain').next().find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.researchDomainSupp').find('.removeResearchDomain').show();
        $('#proposalDetails tr.researchDomainSupp').find('.researchDomainTitle').hide();
        $('#proposalDetails tr.researchDomainSupp').find('.noResearchDomainTitle').show();
        $('#proposalDetails tr.researchDomainSupp').find('.removeResearchDomain').click(function(){$(this).closest('tr').remove();});
    }              
}

function showOrHideOtherResearchField(){
    var other = false;
    $('select[name^=proposalDetails[researchFields]]').each(function() {
       var value = this.value;
       if (value === 'OTHER'){
           other = true;
       }
    });
    if (other === false){
        $('#otherResearchFieldField').hide();
        $('#otherResearchField').val("NA");
    } else {
        $('#otherResearchFieldField').show();
        if($('#otherResearchField').val() === "NA") {
            $('#otherResearchField').val("");
        }
    }        
}

function addResearchField(){
    var researchFieldHtml = '<tr valign="top" class="researchFieldSupp">' + $('#firstResearchField').html() + '</tr>';
    if ($("#proposalDetails tr.researchFieldSupp")[0]){
        $('#proposalDetails tr.researchFieldSupp:last').after(researchFieldHtml);
        $('#proposalDetails tr.researchFieldSupp:last').find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.researchFieldSupp:last').find('.removeResearchField').show();
        $('#proposalDetails tr.researchFieldSupp:last').find('.removeResearchField').click(function(){$(this).closest('tr').remove();});
        $('#proposalDetails tr.researchFieldSupp:last').find('.researchFieldTitle').hide();
        $('#proposalDetails tr.researchFieldSupp:last').find('.noResearchFieldTitle').show();
        $('#proposalDetails tr.researchFieldSupp:last').find('select').change(showOrHideOtherResearchField);
    } else {
        $('#firstResearchField').after(researchFieldHtml);
        $('#firstResearchField').next().find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.researchFieldSupp').find('.removeResearchField').show();
        $('#proposalDetails tr.researchFieldSupp').find('.researchFieldTitle').hide();
        $('#proposalDetails tr.researchFieldSupp').find('.noResearchFieldTitle').show();
        $('#proposalDetails tr.researchFieldSupp').find('.removeResearchField').click(function(){$(this).closest('tr').remove();showOrHideOtherResearchField();});
        $('#proposalDetails tr.researchFieldSupp').find('select').change(showOrHideOtherResearchField);
    }              
}

function showOrHideProposalTypes(){
    var value = $("input:radio[name='proposalDetails[withHumanSubjects]']:checked").val();
    if (value === PROPOSAL_DETAIL_NO || typeof value === "undefined") {
         $('#firstProposalType').hide();
         $('#addAnotherType').hide();
         $('#otherProposalTypeField').hide();
         $('#otherProposalType').val("NA");
         $("#proposalDetails tr.proposalTypeSupp").remove();
         if (!$('#proposalType option[value="PNHS"]').length > 0){
             $('#proposalType').append('<option value="PNHS"></option>');
         }
         $('#proposalType').val("PNHS");
    } else {
         $('#firstProposalType').show();
         $('#addAnotherType').show();
         if ($('#proposalType option[value="PNHS"]').length > 0){
             $('#proposalType option[value="PNHS"]').remove();
         }
    }
}  

function addProposalType(){
    var proposalTypeHtml = '<tr valign="top" class="proposalTypeSupp">' + $('#firstProposalType').html() + '</tr>';
    if ($("#proposalDetails tr.proposalTypeSupp")[0]){
        $('#proposalDetails tr.proposalTypeSupp:last').after(proposalTypeHtml);
        $('#proposalDetails tr.proposalTypeSupp:last').find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.proposalTypeSupp:last').find('.removeProposalType').show();
        $('#proposalDetails tr.proposalTypeSupp:last').find('.removeProposalType').click(function(){$(this).closest('tr').remove();});
        $('#proposalDetails tr.proposalTypeSupp:last').find('select').change(showOrHideOtherProposalType);
    } else {
        $('#firstProposalType').after(proposalTypeHtml);
        $('#firstProposalType').next().find('select').attr('selectedIndex', 0);
        $('#proposalDetails tr.proposalTypeSupp').find('.removeProposalType').show();
        $('#proposalDetails tr.proposalTypeSupp').find('.removeProposalType').click(function(){$(this).closest('tr').remove();});
        $('#proposalDetails tr.proposalTypeSupp').find('select').change(showOrHideOtherProposalType);
    }             
}

function showOrHideOtherProposalType(){
    var other = false;
    $('select[name^=proposalDetails[proposalTypes]]').each(function() {
       var value = this.value;
       if (value === 'OTHER'){
           other = true;
       }
    });
    if (other === false){
        $('#otherProposalTypeField').hide();
        $('#otherProposalType').val("NA");
    } else {
        $('#otherProposalTypeField').show();
        if($('#otherProposalType').val() === "NA") {
            $('#otherProposalType').val("");
        }
    }        
}

function showOrHideOtherErcDecision(){
    var value = $("input:radio[name='proposalDetails[reviewedByOtherErc]']:checked").val();
    if (value === PROPOSAL_DETAIL_NO || typeof value === "undefined") {
        $('#otherErcDecisionField').hide();
        if (!$('#otherErcDecision option[value="1"]').length > 0){
            $('#otherErcDecision').append('<option value="1"></option>');
        }
        $('#otherErcDecision').val("1");
    } else {
       $('#otherErcDecisionField').show();
       if ($('#otherErcDecision option[value="1"]').length > 0){
           $('#otherErcDecision option[value="1"]').remove();
       }
    }
}      

function isNumeric(){
    var numericExpression = /^([\s]*[0-9]+[\s]*)+$/;
    $('#sources input.sourceAmount').each(function() {
        if ($(this).val().match(numericExpression)){
            displayTotalBudget();
            return true;
        } else {
            alert(SOURCE_AMOUNT_NUMERIC);
            $(this).focus();
            return false;
        }   
    });
}

function displayTotalBudget(){
    var totalBudget = Number(0);
    $('#sources input.sourceAmount').each(function() {
        totalBudget += Number($(this).val());
    });            
    $("#totalBudgetVar").html(totalBudget);
}

function showOrHideOtherSource() {
    $("#sources select[id$=-institution]").each(function () {
        var iterator = $(this).attr('id');
        iterator = iterator.replace('sources-', '');
        iterator = iterator.replace('-institution', '');

        var value = this.value;
        var idTr = "sources-"+iterator+"-otherInstitution";
        if(value === "OTHER"){
            $('#' + idTr).show();
            if($('#sources-'+iterator+'-otherInstitutionName').val() === 'NA'){
                $('#sources-'+iterator+'-otherInstitutionName').val('');
            }
            if($('#sources-'+iterator+'-otherInstitutionAcronym').val() === 'NA'){
                $('#sources-'+iterator+'-otherInstitutionAcronym').val('');
            }
            if ($('#sources-'+iterator+'-otherInstitutionType option[value="NA"]').length > 0){
                $('#sources-'+iterator+'-otherInstitutionType option[value="NA"]').remove();
            }
            if ($('#sources-'+iterator+'-radioInternationalSupp').length > 0) {
                $('#sources-'+iterator+'-radioInternationalSupp').remove();
            }
        } else {
            $('#' + idTr).hide();
            $('#sources-'+iterator+'-otherInstitutionName').val('NA');
            $('#sources-'+iterator+'-otherInstitutionAcronym').val('NA');
            if (!$('#sources-'+iterator+'-otherInstitutionType option[value="NA"]').length > 0){
                $('#sources-'+iterator+'-otherInstitutionType').append('<option value="NA"></option>');
            }
            $('#sources-'+iterator+'-otherInstitutionType').val('NA');
            if (!$('#sources-'+iterator+'-radioInternationalSupp').length > 0) {
                $('input[name$="sources['+iterator+'][international]"]:last').closest('label').after($('<label><input type="radio" name="sources['+iterator+'][international]" id="sources-'+iterator+'-radioInternationalSupp" style="display: none;" value="NA"></label>'));                        
            }
            $('#sources-'+iterator+'-radioInternationalSupp').attr('checked',true);     
        }
    });
    showLocationOtherSource();
}

function showLocationOtherSource() {
    $("#sources tr[id$=-otherInstitution]").each(function () {
        
        var iterator = $(this).attr('id');
        iterator = iterator.replace('sources-', '');
        iterator = iterator.replace('-otherInstitution', '');
                
        var value = $("input:radio[name='sources["+iterator+"][international]']:checked").val();

        if (value === INSTITUTION_NATIONAL) {
            $('#sources-'+iterator+'-locationCountryRow').show();
            if ($('#sources-'+iterator+'-locationCountry option[value="0"]').length > 0){
                $('#sources-'+iterator+'-locationCountry option[value="0"]').remove();
            }                
            $('#sources-'+iterator+'-locationInternationalRow').hide();
            if (!$('#sources-'+iterator+'-locationInternational option[value="0"]').length > 0){
                $('#sources-'+iterator+'-locationInternational').append('<option value="0"></option>');
            }
            $('#sources-'+iterator+'-locationInternational').val("0");                
        } else if (value === INSTITUTION_INTERNATIONAL) {
            $('#sources-'+iterator+'-locationCountryRow').hide();
            if (!$('#sources-'+iterator+'-locationCountry option[value="0"]').length > 0){
                $('#sources-'+iterator+'-locationCountry').append('<option value="0"></option>');
            }
            $('#sources-'+iterator+'-locationCountry').val("0");                   
            $('#sources-'+iterator+'-locationInternationalRow').show();
            if ($('#sources-'+iterator+'-locationInternational option[value="0"]').length > 0){
                $('#sources-'+iterator+'-locationInternational option[value="0"]').remove();
            }                  
        } else {
            $('#sources-'+iterator+'-locationCountryRow').hide();
            if (!$('#sources-'+iterator+'-locationCountry option[value="0"]').length > 0){
                $('#sources-'+iterator+'-locationCountry').append('<option value="0"></option>');
            }
            $('#sources-'+iterator+'-locationCountry').val("0");                 

            $('#sources-'+iterator+'-locationInternationalRow').hide();
            if (!$('#sources-'+iterator+'-locationInternational option[value="0"]').length > 0){
                $('#sources-'+iterator+'-locationInternational').append('<option value="0"></option>');
            }
            $('#sources-'+iterator+'-locationInternational').val("0");                 
        }
    });
}

function addSource(){

    // Create the new element "source" based on the first source
    var sourceHtml = '<table width="100%" valign="top" class="sourceSuppClass" style="border-top: dotted 1px #C0C0C0 !important; padding-bottom:10px; padding-top: 10px;">' + $('#firstSource').html() + '</table>';
    
    // Save the value of the radio button (it will be overwritten when placing the source element)
    var radioFirstSourceValue = $("input:radio[name='sources[0][international]']:checked").val();
    
    // Place the new source element at the bottom of the list of sources and get a reference to this element
    if ($("#sources table.sourceSuppClass")[0]){
        $('#sources table.sourceSuppClass:last').after(sourceHtml);
        var lastElement = $('#sources table.sourceSuppClass:last');
    } else {
        $('#firstSource').after(sourceHtml);
        var lastElement = $('#firstSource').next();
    }

    // Get the right iterator for the added source
    var numItems = $('#sources table.sourceSuppClass').length;

    // Correct the name and id attributes with the right iterator, set everything to default, and add the events
    lastElement.find("select[id$=-institution]").attr("id", "sources-"+numItems+"-institution")
                                                .attr("name", "sources["+numItems+"][institution]")
                                                .attr('selectedIndex', 0)
                                                .change(showOrHideOtherSource);
    lastElement.find("input[id$=-amount]").attr("id", "sources-"+numItems+"-amount")
                                          .attr("name", "sources["+numItems+"][amount]")
                                          .val('')
                                          .keyup(isNumeric);
    lastElement.find("tr[id$=-otherInstitution]").attr("id", "sources-"+numItems+"-otherInstitution")
                                                 .hide();
    lastElement.find("input[id$=-otherInstitutionName]").attr("id", "sources-"+numItems+"-otherInstitutionName")
                                                        .attr("name", "sources["+numItems+"][otherInstitutionName]")
                                                        .val('NA');
    lastElement.find("input[id$=-otherInstitutionAcronym]").attr("id", "sources-"+numItems+"-otherInstitutionAcronym")
                                                           .attr("name", "sources["+numItems+"][otherInstitutionAcronym]")
                                                           .val('NA');
    lastElement.find("select[id$=-otherInstitutionType]").attr("id", "sources-"+numItems+"-otherInstitutionType")
                                                         .attr("name", "sources["+numItems+"][otherInstitutionType]")
                                                         .append('<option value="NA"></option>')
                                                         .val('NA');
    lastElement.find("td[id$=-locationInternationalCol]").attr("id", "sources-"+numItems+"-locationInternationalCol");
    if (lastElement.find('#sources input[id=sources-0-radioInternationalSupp]').length > 0) {
        $('#sources-0-radioInternationalSupp').remove();
    }    
    lastElement.find("input:radio").each(function(){$(this).attr("name", "sources["+numItems+"][international]");})
                                   .change(showLocationOtherSource);
    $('<input type="radio" name="sources['+numItems+'][international]" id="sources-'+numItems+'-radioInternationalSupp" style="display: none;" val="NA"/>').appendTo('#sources-'+numItems+'-locationInternationalCol');
    $('#sources-'+numItems+'-radioInternationalSupp').attr('checked',true);    
    lastElement.find("tr[id$=-locationCountryRow]").attr("id", "sources-"+numItems+"-locationCountryRow");
    lastElement.find("select[id$=-locationCountry]").attr("id", "sources-"+numItems+"-locationCountry")
                                                    .attr("name", "sources["+numItems+"][locationCountry]")
                                                    .append('<option value="0"></option>')
                                                    .val('0');
    lastElement.find("tr[id$=-locationInternationalRow]").attr("id", "sources-"+numItems+"-locationInternationalRow");
    lastElement.find("select[id$=-locationInternational]").attr("id", "sources-"+numItems+"-locationInternational")
                                                          .attr("name", "sources["+numItems+"][locationInternational]")
                                                          .append('<option value="0"></option>')
                                                          .val('0');
    lastElement.find('.removeSource').show();
    lastElement.find('.removeSource').click(function(){$(this).closest('table').remove();displayTotalBudget();});
    
    // Set back the radio button of the first source
    $('#sources input[name="sources[0][international]"][value="'+radioFirstSourceValue+'"]').attr('checked',true);    
}       

function showOrHideExportHumanTissue(){
    var value = $("#riskAssessment input:radio[name='riskAssessment[bioSamples]']:checked").val();
    if (value === RISK_ASSESSMENT_NO || typeof value === "undefined") {
         $('#exportHumanTissueField').hide();
         if(!$('#hiddenExportHumanTissueRadio').length){
            $('#exportHumanTissueField').append($('<input type="radio" name="riskAssessment[exportHumanTissue]" id="hiddenExportHumanTissueRadio" value="NA">'));
         }
         $('#hiddenExportHumanTissueRadio').attr('checked', 'checked');
    } else {
         $('#exportHumanTissueField').show();
         $('#hiddenExportHumanTissueRadio').remove();
    }
    showOrHideExportReason();
}

function showOrHideExportReason(){
    var value = $("#riskAssessment input:radio[name='riskAssessment[exportHumanTissue]']:checked").val();
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

function showOrHideOtherLevelOfRisk(){
    var value = $("#riskLevel").val();
    if (value === RISK_ASSESSMENT_NO_MORE_THAN_MINIMAL || typeof value === "undefined" || value === "") {
        $('#listRisksField').hide();
        $('#howRisksMinimizedField').hide();
        $('#listRisks').val("NA");
        $('#howRisksMinimized').val("NA");
    } else {
        $('#listRisksField').show();
        $('#howRisksMinimizedField').show();
        if ($('#listRisks').val() === "NA") {
            $('#listRisks').val("");
        }
        if ($('#howRisksMinimized').val() === "NA") {
            $('#howRisksMinimized').val("");
        }
    }
}
