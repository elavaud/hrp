{**
 * summary.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the author's submission summary table.
 *
 * $Id$
 *}
<div id="submission">
<h3>{translate key="article.submission"}</h3>

<table width="100%" class="data">
	<tr>
		<td class="label" width="20%">{translate key="article.title"}</td>
		<td class="value" width="80%">{$abstract->getScientificTitle()|strip_unsafe_html}</td>
	</tr>
</table>
</div>

