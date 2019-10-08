{**
* javascript.tpl
*
* Template file realizing the bridge between javascript and template files for the generation of reports. 
**}

{literal}
    <script type="text/javascript">
    
       var PROPOSAL_DETAIL_NO = "{/literal}{$smarty.const.PROPOSAL_DETAIL_NO}{literal}";
       var PROPOSAL_DETAIL_YES = "{/literal}{$smarty.const.PROPOSAL_DETAIL_YES}{literal}";
       var INITIAL_REVIEW = "{/literal}{$smarty.const.INITIAL_REVIEW}{literal}";
       var SUBMISSION_SECTION_DECISION_APPROVED = "{/literal}{$smarty.const.SUBMISSION_SECTION_DECISION_APPROVED}{literal}";
       var OR_STRING = "{/literal}{translate key='common.or'}{literal}";
       var SOURCE_AMOUNT_NUMERIC = "{/literal}{translate key="proposal.source.amount.instruct"}{literal}";

       var RISK_ASSESSMENT_NO = "{/literal}{$smarty.const.RISK_ASSESSMENT_NO}{literal}";
    
       $(document).ready(function() {
            
            $('#showOrHideDecisionTableClick').click(showOrHideDecisionTable);
            
            // Decision date - Implement the "date picker" event and restrict the dates to select
            $( "#decisionAfter" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', maxDate: '-1 d', onSelect: changeDecisionBeforeDate});    
            $( "#decisionBefore" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', maxDate: '0', onSelect: changeDecisionAfterDate});

            $('#showOrHideDetailsTableClick').click(showOrHideDetailsTable);

            // Clear radio buttons for student initiated research
            $('#clearStudentResearch').click(function(){$('#filterBy input:radio[name="studentInitiatedResearch"]').attr('checked', false);});

            // Research dates - Implement the "date picker" event and restrict the dates to select
            $( "#startAfter" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', onSelect: researchStartAfterChanged});        
            $( "#startBefore" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', onSelect: researchStartBeforeChanged});
            $( "#endAfter" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', onSelect: researchEndAfterChanged});            
            $( "#endBefore" ).datepicker({changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', onSelect: researchEndBeforeChanged});

            $('#addAnotherKIIClick').click(addKII);

            $('#filterBy input:radio[name="multiCountryResearch"]').change(showOrHideCountryFields);

            $('#clearMultiCountryResearch').click(function(){$('#filterBy input:radio[name="multiCountryResearch"]').attr('checked', false);showOrHideCountryFields();});

            $('#addAnotherCountryClick').click(addCountry);
            
            $('#addAnotherAreaClick').click(addGeoArea);            

            $('#addAnotherResearchDomainClick').click(addResearchDomain);

            $('#addAnotherResearchFieldClick').click(addResearchField);

            $('#filterBy input:radio[name="withHumanSubjects"]').change(showOrHideProposalTypes);

            $('#clearWithHumanSubjects').click(function(){$('#filterBy input:radio[name="withHumanSubjects"]').attr('checked', false);showOrHideProposalTypes();});

            $('#addAnotherTypeClick').click(addProposalType);
            
            $('#showOrHideSourcesTableClick').click(showOrHideSourcesTable);
            
            $("#budget").keyup(isNumeric);
            
            $('#addAnotherSourceClick').click(addSource);
                        
            $('#showOrHideRiskAssessmentTableClick').click(showOrHideRiskAssessmentTable);

            $('#clearIdentityRevealed').click(function(){$('#riskAssessmentTable input:radio[name="identityRevealed"]').attr('checked', false);});

            $('#clearUnableToConsent').click(function(){$('#riskAssessmentTable input:radio[name="unableToConsent"]').attr('checked', false);});

            $('#clearUnder18').click(function(){$('#riskAssessmentTable input:radio[name="under18"]').attr('checked', false);});

            $('#clearDependentRelationship').click(function(){$('#riskAssessmentTable input:radio[name="dependentRelationship"]').attr('checked', false);});

            $('#clearEthnicMinority').click(function(){$('#riskAssessmentTable input:radio[name="ethnicMinority"]').attr('checked', false);});
            
            $('#clearImpairment').click(function(){$('#riskAssessmentTable input:radio[name="impairment"]').attr('checked', false);});
            
            $('#clearPregnant').click(function(){$('#riskAssessmentTable input:radio[name="pregnant"]').attr('checked', false);});
            
            $('#clearNewTreatment').click(function(){$('#riskAssessmentTable input:radio[name="newTreatment"]').attr('checked', false);});
            
            $('#clearBioSamples').click(function(){$('#riskAssessmentTable input:radio[name="bioSamples"]').attr('checked', false);showOrHideExportHumanTissue()});
            
            $('#clearExportHumanTissue').click(function(){$('#riskAssessmentTable input:radio[name="exportHumanTissue"]').attr('checked', false);showOrHideExportReason();});            

            $("[name='bioSamples']").change(showOrHideExportHumanTissue);

            $("[name='exportHumanTissue']").change(showOrHideExportReason);
        
            $('#clearRadiation').click(function(){$('#riskAssessmentTable input:radio[name="radiation"]').attr('checked', false);});
            
            $('#clearDistress').click(function(){$('#riskAssessmentTable input:radio[name="distress"]').attr('checked', false);});
            
            $('#clearInducements').click(function(){$('#riskAssessmentTable input:radio[name="inducements"]').attr('checked', false);});
            
            $('#clearSensitiveInfo').click(function(){$('#riskAssessmentTable input:radio[name="sensitiveInfo"]').attr('checked', false);});

            $('#clearReproTechnology').click(function(){$('#riskAssessmentTable input:radio[name="reproTechnology"]').attr('checked', false);});

            $('#clearGenetic').click(function(){$('#riskAssessmentTable input:radio[name="genetic"]').attr('checked', false);});

            $('#clearStemCell').click(function(){$('#riskAssessmentTable input:radio[name="stemCell"]').attr('checked', false);});

            $('#clearBiosafety').click(function(){$('#riskAssessmentTable input:radio[name="biosafety"]').attr('checked', false);});
            
            $('#reportType').change(showSelectedReportType);
            
            showOrHideDecisionTable();
            
            showOrHideDetailsTable();
            
            showOrHideCountryFields();
               
            showOrHideProposalTypes();
            
            showOrHideSourcesTable();
            
            showOrHideRiskAssessmentTable();
            
            showOrHideExportHumanTissue();
            
            showSelectedReportType();

        });
    </script>
    <!-- Datepicker bug: see http://bugs.jqueryui.com/ticket/5970 -->
    <style type="text/css">
         #ui-datepicker-div { display:none }
    </style>
{/literal}
