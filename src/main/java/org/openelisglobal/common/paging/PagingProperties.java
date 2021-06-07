package org.openelisglobal.common.paging;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class PagingProperties {

    @Value("${org.openelisglobal.paging.results.pageSize:99}")
    private Integer resultsPageSize;

    @Value("${org.openelisglobal.paging.validation.pageSize:99}")
    private Integer validationPageSize;

    public Integer getResultsPageSize() {
        return resultsPageSize;
    }

    public void setResultsPageSize(Integer resultsPageSize) {
        this.resultsPageSize = resultsPageSize;
    }

    public Integer getValidationPageSize() {
        return validationPageSize;
    }

    public void setValidationPageSize(Integer validationPageSize) {
        this.validationPageSize = validationPageSize;
    }

}
