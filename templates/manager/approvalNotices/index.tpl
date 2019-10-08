{**
 * index.tpl
 *
 * About Files manager.
 *
 *}
{strip}
    {assign var="pageTitle" value="manager.approvalNotices"}
    {include file="common/header.tpl"}
{/strip}

<p>{translate key="manager.approvalNotice.description"}</p>

<div id="notices">
    <h3>{translate key="manager.approvalNotice.s"}</h3>
    <table class="listing" width="100%">
        <tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
        <tr>
            <td width="40%">{translate key="common.title"}</td>
            <td width="20%">{translate key="manager.approvalNotice.committees.short"}</td>
            <td width="20%">{translate key="manager.approvalNotice.reviewTypes.short"}</td>
            <td width="10%">{translate key="manager.approvalNotice.active"}</td>
            <td width="10%" align="right">{translate key="common.action"}</td>
        </tr>
        <tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
        {iterate from=notices item=notice}
            <tr>
                <td><a href="{url op="approvalNoticeEdit" path=$notice->getId()}">{$notice->getApprovalNoticeTitle()|strip_unsafe_html|truncate:80:"..."}</a></td>
                <td>{$notice->getCommitteesAcronyms()|strip_unsafe_html|truncate:60:"..."}</td>
                <td>{$notice->getReviewTypesList()|escape}</td>
                <td>{translate key=$notice->getActiveKey()|escape}</td>
                <td align="right">
                    <a href="{url op="approvalNoticeEdit" path=$notice->getId()}" class="action" >{translate key="common.edit"}</a>
                    <a href="{url op="approvalNoticeDelete" path=$notice->getId()}" class="action" onclick="return confirm('{translate|escape:"jsparam" key="manager.approvalNotice.delete"}')">{translate key="common.delete"}</a>
                    <a href="{url op="approvalNoticePreview" path=$notice->getId()}" class="action">{translate key="common.preview"}</a>
                </td>
            </tr>
            <tr>
                <td colspan="5" class="{if $notices->eof()}end{/if}separator">&nbsp;</td>
            </tr>
        {/iterate}
        {if $notices->wasEmpty()}
            <tr>
                <td colspan="5" class="nodata">{translate key="common.none"}</td>
            </tr>
            <tr>
                <td colspan="5" class="endseparator">&nbsp;</td>
            </tr>
        {else}
            <tr>
                <td colspan="3" align="left">{page_info iterator=$notices}</td>
                <td colspan="2" align="right">{page_links anchor="notices" name="notices" iterator=$notices}</td>
            </tr>
        {/if}
    </table>
</div>

<p><a href="{url op="approvalNoticeEdit"}" class="action" >{translate key="manager.approvalNotice.new"}</a></p>

{include file="common/footer.tpl"}

