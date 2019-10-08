{**
 * authors.tpl
 *
 * authors section of the Step 2 of author article submission.
 *
 *}


<div id="authors">
    
    <h3>{translate key="user.role.primaryInvestigator"}</h3>

    <input type="hidden" name="deletedAuthors" value="{$deletedAuthors|escape}" />
    <input type="hidden" name="moveAuthor" value="0" />
    <input type="hidden" name="moveAuthorDir" value="" />
    <input type="hidden" name="moveAuthorIndex" value="" />

    {foreach name=authors from=$authors key=authorIndex item=author}
        <input type="hidden" name="authors[{$authorIndex|escape}][authorId]" value="{$author.authorId|escape}" />
        <input type="hidden" name="authors[{$authorIndex|escape}][seq]" value="{$authorIndex+1}" />

        {if $smarty.foreach.authors.total <= 1}
            <input type="hidden" name="primaryContact" value="{$authorIndex|escape}" />
        {/if}

        {if $authorIndex == 1}
            <h3>{translate key="user.role.coinvestigator"}</h3>
        {/if}
        
        <table width="100%" class="data">
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-firstName" required="true" key="user.firstName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][firstName]" id="authors-{$authorIndex|escape}-firstName" value="{$author.firstName|escape}" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-middleName" key="user.middleName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][middleName]" id="authors-{$authorIndex|escape}-middleName" value="{$author.middleName|escape}" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-lastName" required="true" key="user.lastName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][lastName]" id="authors-{$authorIndex|escape}-lastName" value="{$author.lastName|escape}" size="20" maxlength="90" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-email" required="true" key="user.email"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][email]" id="authors-{$authorIndex|escape}-email" value="{$author.email|escape}" size="30" maxlength="90" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-phone" required="true" key="user.tel"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][phone]" id="authors-{$authorIndex|escape}-phone" value="{$author.phone|escape}" size="20" /></td>
            </tr>            
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-affiliation" required="true" key="user.affiliation"}</td>
                <td width="80%" class="value"><textarea name="authors[{$authorIndex|escape}][affiliation]" class="textArea" id="authors-{$authorIndex|escape}-affiliation" rows="5" cols="40">{$author.affiliation|escape}</textarea><br/>
                    <span class="instruct">{translate key="user.affiliation.description"}</span>
                </td>
            </tr>

            {if $currentJournal->getSetting('requireAuthorCompetingInterests')}
                <tr valign="top">
                    <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-competingInterests" key="author.competingInterests" competingInterestGuidelinesUrl=$competingInterestGuidelinesUrl}</td>
                    <td width="80%" class="value"><textarea name="authors[{$authorIndex|escape}][competingInterests][{$eng|escape}]" class="textArea" id="authors-{$authorIndex|escape}-competingInterests" rows="5" cols="40">{$author.competingInterests[$formLocale]|escape}</textarea></td>
                </tr>
            {/if}{* requireAuthorCompetingInterests *}

            {call_hook name="Templates::Author::Submit::Authors"}

            {if $smarty.foreach.authors.total > 1}
                <tr valign="top">
                    <td width="80%" class="value" colspan="2">
                        <div style="display:none">
                            <input type="radio" name="primaryContact" value="{$authorIndex|escape}"{if $primaryContact == $authorIndex} checked="checked"{/if} /> <label for="primaryContact">{*translate key="author.submit.selectPrincipalContact"*}</label>
                        </div>
                        {if $authorIndex > 0}
                            <input type="submit" name="delAuthor[{$authorIndex|escape}]" value="{*translate key="author.submit.deleteAuthor"*}Delete Co-Investigator" class="button" />
                        {else}
                            &nbsp;
                        {/if}
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><br/></td>
                </tr>
            {/if}
        </table>
    {/foreach}
    <br /><br />
    {if $authorIndex<5}
        <p><input type="submit" class="button" name="addAuthor" value="{*translate key="author.submit.addAuthor"*}Add a Co-Investigator" /></p>
    {/if}
</div>

<div class="separator"></div>