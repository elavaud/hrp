{**
 * titleAndAbstracts.tpl
 *
 * Titles and Abstracts section of the Step 2 of author article submission.
 *
 *}


<div id="titleAndAbstract">
    
    <h3>{translate key="submission.titleAndAbstract"}</h3>

    {foreach from=$abstractLocales item=localeName key=localeKey}
        
        {assign var="abstract" value=$abstracts[$localeKey]}
        
        {if $abstract}
            <input type="hidden" name="abstracts[{$localeKey|escape}][abstractId]" value="{$abstract.abstractId|escape}" />

            <h6>{$localeName} {translate key="common.language"}</h6>

            <table width="100%" class="data">
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr valign="top" id="scientificTitleField">
                    <td title="{translate key="proposal.scientificTitleInstruct"}" width="20%" class="label">[?] {fieldLabel name="scientificTitle" required="true" key="proposal.scientificTitle"}</td>
                    <td width="80%" class="value"><input type="text" class="textField" name="abstracts[{$localeKey|escape}][scientificTitle]" id="scientificTitle" value="{$abstract.scientificTitle|escape}" size="50" maxlength="255" /></td>
                </tr>
                <tr valign="top" id="publicTitleField">
                    <td title="{translate key="proposal.publicTitleInstruct"}" width="20%" class="label">[?] {fieldLabel name="publicTitle" required="true" key="proposal.publicTitle"}</td>
                    <td width="80%" class="value"><input type="text" class="textField" name="abstracts[{$localeKey|escape}][publicTitle]" id="publicTitle" value="{$abstract.publicTitle|escape}" size="50" maxlength="255" /></td>
                </tr>
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr valign="top" id="backgroundField">
                    <td title="{translate key="proposal.backgroundInstruct"}" width="20%" class="label">[?] {fieldLabel name="background" required="true" key="proposal.background"}</td>
                    <td width="80%" class="value"><textarea name="abstracts[{$localeKey|escape}][background]" id="background" class="textArea" rows="5" cols="70" maxlength="1200">{$abstract.background|escape}</textarea><br/><i>200 {translate key="proposal.xWordsMax"}</i></td>
                </tr>
                <tr valign="top" id="objectivesField">
                    <td title="{translate key="proposal.objectivesInstruct"}" width="20%" class="label">[?] {fieldLabel name="objectives" required="true" key="proposal.objectives"}</td>
                    <td width="80%" class="value"><textarea name="abstracts[{$localeKey|escape}][objectives]" id="objectives" class="textArea" rows="5" cols="70" maxlength="1200">{$abstract.objectives|escape}</textarea><br/><i>300 {translate key="proposal.xWordsMax"}</i></td>
                </tr>
                <tr valign="top" id="studyMethodsField">
                    <td title="{translate key="proposal.studyMethodsInstruct"}" width="20%" class="label">[?] {fieldLabel name="studyMethods" required="true" key="proposal.studyMethods"}</td>
                    <td width="80%" class="value"><textarea name="abstracts[{$localeKey|escape}][studyMethods]" id="studyMethods" class="textArea" rows="5" cols="70" maxlength="1800">{$abstract.studyMethods|escape}</textarea><br/><i>300 {translate key="proposal.xWordsMax"}</i></td>
                </tr>  
                <tr valign="top" id="expectedOutcomesField">
                    <td title="{translate key="proposal.expectedOutcomesInstruct"}" width="20%" class="label">[?] {fieldLabel name="expectedOutcomes" required="true" key="proposal.expectedOutcomes"}</td>
                    <td width="80%" class="value"><textarea name="abstracts[{$localeKey|escape}][expectedOutcomes]" id="expectedOutcomes" class="textArea" rows="5" cols="70" maxlength="1800">{$abstract.expectedOutcomes|escape}</textarea><br/><i>200 {translate key="proposal.xWordsMax"}</i></td>
                </tr>   
                <tr><td colspan="2">&nbsp;</td></tr>
                <tr valign="top" id="keywordsField">
                    <td title="{translate key="proposal.keywordsInstruct"}" width="20%" class="label">[?] {fieldLabel name="keywords" required="true" key="proposal.keywords"}</td>
                    <td width="80%" class="value"><input type="text" class="textField" name="abstracts[{$localeKey|escape}][keywords]" id="keywords" value="{$abstract.keywords|escape}" size="50" maxlength="255" /></td>
                </tr>
            </table>
        {/if}
    {/foreach}
</div>
<div class="separator"></div>