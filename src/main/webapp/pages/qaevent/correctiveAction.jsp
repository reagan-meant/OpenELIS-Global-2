<%--
  Created by IntelliJ IDEA.
  User: kenny
  Date: 2019-09-15
  Time: 13:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
         import="org.openelisglobal.common.action.IActionConstants,
				org.openelisglobal.common.formfields.FormFields,
                org.openelisglobal.common.formfields.FormFields.Field,
                org.openelisglobal.common.provider.validation.AccessionNumberValidatorFactory,
                org.openelisglobal.common.provider.validation.IAccessionNumberValidator,
                org.openelisglobal.common.provider.validation.NonConformityRecordNumberValidationProvider,
                org.openelisglobal.common.services.PhoneNumberService,
                org.openelisglobal.common.util.DateUtil,
                org.openelisglobal.internationalization.MessageUtil,
                org.openelisglobal.common.util.Versioning,
                org.openelisglobal.qaevent.valueholder.retroCI.QaEventItem,
                org.openelisglobal.common.util.ConfigurationProperties" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>

<%@ page isELIgnored="false" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="ajax" uri="/tags/ajaxtags" %>

<%
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    String today = df.format(Calendar.getInstance().getTime());
%>
<link rel="stylesheet" href="css/jquery_ui/jquery.ui.all.css?ver=<%= Versioning.getBuildNumber() %>">
<link rel="stylesheet" href="css/customAutocomplete.css?ver=<%= Versioning.getBuildNumber() %>">

<script src="scripts/ui/jquery.ui.core.js?ver=<%= Versioning.getBuildNumber() %>"></script>
<script src="scripts/ui/jquery.ui.widget.js?ver=<%= Versioning.getBuildNumber() %>"></script>
<script src="scripts/ui/jquery.ui.button.js?ver=<%= Versioning.getBuildNumber() %>"></script>
<script src="scripts/ui/jquery.ui.menu.js?ver=<%= Versioning.getBuildNumber() %>"></script>
<script src="scripts/ui/jquery.ui.position.js?ver=<%= Versioning.getBuildNumber() %>"></script>
<script src="scripts/ui/jquery.ui.autocomplete.js?ver=<%= Versioning.getBuildNumber() %>"></script>
<script src="scripts/customAutocomplete.js?ver=<%= Versioning.getBuildNumber() %>"></script>
<script src="scripts/utilities.js?ver=<%= Versioning.getBuildNumber() %>"></script>
<script src="scripts/ajaxCalls.js?ver=<%= Versioning.getBuildNumber() %>"></script>

<div align="center">
    <h2><spring:message code="nonconforming.page.correctiveAction.title" /></h2>

    <select id="searchCriteria" tabindex="1" class="patientSearch">
        <option value="<c:out value="1" />">Lab Order Number</option>
        <option value="<c:out value="2" />">NCE Number</option>
    </select>
    <input type="text" name="searchValue"
           value="" onkeyup="enableSearch()" onpaste="enableSearch()" id="searchValue">
    &nbsp;
    <input type="button" id="searchButtonId"
           value='<spring:message code="label.button.search" />'
           onclick="searchNCE();" disabled />

    <table id="searchResults">

    </table>

</div>
<c:if test="${not empty form.labOrderNumber}">
    <h2><spring:message code="nonconforming.page.correctiveAction.title" /></h2>
    <form:hidden path="currentUserId" />
    <form:hidden path="status" />
    <form:hidden path="reportDate" />
    <form:hidden path="reporterName" />
    <form:hidden path="prescriberName" />
    <form:hidden path="site" />
    <form:hidden path="nceNumber" />
    <form:hidden path="dateOfEvent" />
    <form:hidden path="labOrderNumber" />
    <form:hidden path="specimen" />
    <form:hidden path="reportingUnit" />
    <form:hidden path="description" />
    <form:hidden path="suspectedCauses" />
    <form:hidden path="proposedAction" />
    <form:hidden path="laboratoryComponent" />
    <form:hidden path="nceCategory" />
    <form:hidden path="nceType" />
    <form:hidden path="consequences" />
    <form:hidden path="recurrence" />
    <form:hidden path="severityScore" />
    <form:hidden path="colorCode" />
    <form:hidden path="correctiveAction" />
    <form:hidden path="controlAction" />
    <form:hidden path="comments" />

    <table class="corrective-action-section-1">
        <tr>
            <td class="half-table"><spring:message code="nonconforming.event.ncenumber" /></td>
            <td><c:out value="${form.nceNumber}" /></td>
        </tr>
        <tr>
            <td class="half-table"><spring:message code="nonconforming.page.followUp.ncedate" /></td>
            <td><c:out value="${form.dateOfEvent}" /></td>
        </tr>
        <tr>
            <td class="half-table"><spring:message code="nonconforming.page.followUp.severity" /></td>
            <td><c:out value="${form.consequences}" /></td>
        </tr>

        <tr>
            <td class="half-table"><spring:message code="nonconforming.page.followUp.reportingPerson" /></td>
            <td><c:out value="${form.name}" /></td>
        </tr>
        <tr>
            <td class="half-table"><spring:message code="nonconforming.page.correctiveAction.reportingDate" /></td>
            <td><c:out value="${form.reportDate}" /></td>
        </tr>
        <tr>
            <td class="half-table"><spring:message code="nonconforming.event.reportingUnit" /></td>
            <td><c:out value="${form.reportingUnit}" /></td>
        </tr>

        <tr>
            <td class="half-table"><spring:message code="nonconforming.event.laborderNumber" /></td>
            <td><c:out value="${form.labOrderNumber}" /></td>
        </tr>
        <tr>
            <td class="half-table"><spring:message code="nonconforming.event.specimen" /></td>
            <td><c:out value="${form.specimen}" /></td>
        </tr>
        <tr>
            <td class="half-table"><spring:message code="nonconforming.page.correctiveAction.laboratoryComponent" /></td>
            <td><c:out value="${form.laboratoryComponent}" /></td>
        </tr>
        <tr>
            <td class="half-table"><spring:message code="nonconforming.page.followUp.nceCategory" /></td>
            <td><c:out value="${form.nceCategory }" /></td>
        </tr>
        <tr>
            <td class="half-table"><spring:message code="nonconforming.page.followUp.nceType" /></td>
            <td><c:out value="${form.nceType}" /></td>
        </tr>
    </table>

    <table class="corrective-action-section-2">
        <tr>
            <td>
                <spring:message code="nonconforming.page.correctiveAction.plannedAction" />
                 <p><c:out value="${form.correctiveAction}" /></p>
            </td>
        </tr>
        <tr>
            <td>
                <spring:message code="nonconforming.page.correctiveAction.plannedPreventive" />
                <p><c:out value="${form.controlAction}" /></p>
            </td>
        </tr>
        <tr>
            <td>
                <spring:message code="nonconforming.page.followUp.comments" />
                <p><c:out value="${form.comments}" /></p>
            </td>
        </tr>
    </table>

    <table class="full-table">
        <caption><spring:message code="nonconforming.page.correctiveAction.log" /></caption>
        <tr>
            <td class="column-right-text"><spring:message code="nonconforming.page.correctiveAction.discussionDate" /></td>
            <td><c:out value="${form.discussionDate}" /></td>
        </tr>
        <tr>
            <td></td>
            <td>
                <input type="date" max="<%= today%>"/>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <button id="addNewDate">Add new date</button>
            </td>
        </tr>
    </table>
    <table class="full-table">
        <tr>
            <th>Corrective action</th>
            <th>Action type</th>
            <th>Person responsible</th>
            <th>Date Completed</th>
            <th>Turnaround time</th>
        </tr>
    </table>
    <div class="center-caption"><button id="saveButtonId" onclick="savePage()">Submit</button></div>
    <table class="full-table">
        <caption><spring:message code="nonconforming.page.correctiveAction.nceResolution" /></caption>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td>
                <spring:message code="nonconforming.page.correctiveAction.nceResolutionLabel" />
                <form:radiobutton name="effective" path="effective" value="Yes"/> Yes
                <form:radiobutton name="effective" path="effective" value="No"/> No
            </td>
        </tr>
        <tr>
            <td><spring:message code="nonconforming.page.correctiveAction.signature" /></td>
            <td><spring:message code="nonconforming.page.correctiveAction.dateCompleted" /></td>
        </tr>
    </table>
    <div class="center-caption"><button id="submitResolved" onclick="savePage()">Submit</button></div>
</c:if>

<script type="text/javascript">
    function setSave(disabled) {
        document.getElementById("saveButtonId").disabled = disabled;
    }

    function enableSearch() {
        document.getElementById("searchButtonId").disabled = document.getElementById("searchValue").value === "";
    }

    /**
     *  Saves the form.
     */
    function savePage() {
        var form = document.getElementById("mainForm");
        window.onbeforeunload = null; // Added to flag that formWarning alert isn't needed.
        form.action = "ViewNonConformingEvent.do";
        form.submit();
    }

    /**
     *  Enable/Disable search button based on input
     */
    function enableSearch() {
        document.getElementById("searchButtonId").disabled = document.getElementById("searchValue").value === "";
    }

    function searchNCE() {
        var criteria = jQuery("#searchCriteria").val();
        var value = jQuery("#searchValue").val();
        var nceNumber;
        var labNumber = "";


        if (criteria == 2) {
            nceNumber =  value.trim();
        } else if (criteria == 1) {
            labNumber = value;
        }

        nceSearch(nceNumber, labNumber, "", false, processSearchSuccess);
    }

    function nceSearch(nceNumber, labNumber, guid, suppressExternalSearch, success, failure){
        if( !failure){failure = defaultFailure;	}
        new Ajax.Request (
            'ajaxQueryXML',  //url
            {//options
                method: 'get', //http method
                parameters: "provider=NonConformingEventSearchProvider&nceNumber=" + nceNumber +
                    "&labNumber=" + labNumber + "&status=CAPA" +
                    "&suppressExternalSearch=" + suppressExternalSearch,
                onSuccess:  success,
                onFailure:  failure
            }
        );
    }

    function processSearchSuccess(xhr) {
        console.log(xhr)
        var formField = xhr.responseXML.getElementsByTagName("formfield").item(0);
        var message = xhr.responseXML.getElementsByTagName("message").item(0);

        if (message.firstChild.nodeValue == "valid") {
            jQuery("#searchResults").html("<tr><th>Date</th><th>NCE Number</th><th>Lab Section/Unit</th><th>Severity (Color)</th></tr>");
            var resultNodes = formField.getElementsByTagName("nce");
            for (var i = 0; i < resultNodes.length; i++) {
                document.getElementById("searchResults").insertAdjacentHTML('beforeend', addNCERow(resultNodes[i]));
            }

        }
    }

    function addNCERow(nce) {
        var date = nce.getElementsByTagName("date").item(0);
        var nceNumberEl = nce.getElementsByTagName('ncenumber').item(0);
        var unit = nce.getElementsByTagName('unit').item(0);
        var colorCode = nce.getElementsByTagName('colorCode').item(0);
        var nceNumber = (nceNumberEl ? nceNumberEl.firstChild.nodeValue : "#")
        var row = '<tr><td>' + (date ? date.firstChild.nodeValue : "") + '</td>' +
            '<td><a href="NCECorrectiveAction.do?nceNumber=' + nceNumber + '">' + nceNumber + '</a></td>' +
            '<td>' + (unit ? unit.firstChild.nodeValue : "") + '</td>' +
            '<td>' + (colorCode ? colorCode.firstChild.nodeValue : "") + '</td>' +
            '</tr><tr>';
        return row;
    }

    function checkIfValid() {
        var correctiveAction = jQuery('input[name="correctiveAction"]').val();
        var consequences = jQuery('input[name="consequences"]').val();
        var nceType = jQuery('input[name="nceType"]').val();
        var nceCategory = jQuery('input[name="nceCategory"]').val();
        var laboratoryComponent = 'd'; //jQuery('input[name="laboratoryComponent"]').val();
        setSave(true);
        if (correctiveAction != '' && consequences !== '' && nceType !== '' && nceCategory !== '' && laboratoryComponent != '') {
            setSave(false);
        }
    }

    function resetNceType() {
        var nceCategory = jQuery('select[name="nceCategory"]').val();
        var el = document.getElementById("nceType");
        var j = el.options.length - 1;
        while (j > 0) {
            el.remove(j);
            j--;
        }

        for (var i = 0; i < nceTypes.length; i++) {
            var nce = nceTypes[i];
            if (nce.categoryId == nceCategory) {
                el.append(new Option(nce.name, nce.id));
            }
        }
    }

    function calculateSeverityScore() {
        var consequences = jQuery('select[name="consequences"]').val();
        var recurrence = jQuery('select[name="recurrence"]').val();
        if (consequences != '' && recurrence != '') {
            var score = Number(consequences) * Number(recurrence);
            document.getElementById("severityScoreLabel").innerHTML = score;
            document.getElementById("severityScore").value = score;
            if (score >= 1 && score <= 3) {
                document.getElementById("colorCode").value = 'Green';
            } else if (score >= 4 && score <= 6) {
                document.getElementById("colorCode").value = 'Yellow';
            } else if (score >= 7 && score <= 9) {
                document.getElementById("colorCode").value = 'Red';
            }
        }
        checkIfValid();
    }

    function addNewDate(e) {
        e.preventDefault();
    }

    jQuery(document).ready( function() {
        setSave(true);
        document.getElementById("addNewDate").addEventListener("click", addNewDate);
    });

</script>
