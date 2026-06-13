package com.wangziyang.mes.productionorder.request;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Standard ERP order sync request.
 */
public class SpProductionOrderErpSyncReq {

    private List<Order> orders = new ArrayList<>();

    public List<Order> getOrders() {
        return orders;
    }

    public void setOrders(List<Order> orders) {
        this.orders = orders;
    }

    public static class Order {
        private String erpSourceNo;
        private String sourceType;
        private String customerName;
        private String customerGroup;
        private String salesContractNo;
        private String businessType;
        private String orderDate;
        private String schedulingMethod;
        private String remark;
        private List<Item> items = new ArrayList<>();

        public String getErpSourceNo() { return erpSourceNo; }
        public void setErpSourceNo(String erpSourceNo) { this.erpSourceNo = erpSourceNo; }
        public String getSourceType() { return sourceType; }
        public void setSourceType(String sourceType) { this.sourceType = sourceType; }
        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }
        public String getCustomerGroup() { return customerGroup; }
        public void setCustomerGroup(String customerGroup) { this.customerGroup = customerGroup; }
        public String getSalesContractNo() { return salesContractNo; }
        public void setSalesContractNo(String salesContractNo) { this.salesContractNo = salesContractNo; }
        public String getBusinessType() { return businessType; }
        public void setBusinessType(String businessType) { this.businessType = businessType; }
        public String getOrderDate() { return orderDate; }
        public void setOrderDate(String orderDate) { this.orderDate = orderDate; }
        public String getSchedulingMethod() { return schedulingMethod; }
        public void setSchedulingMethod(String schedulingMethod) { this.schedulingMethod = schedulingMethod; }
        public String getRemark() { return remark; }
        public void setRemark(String remark) { this.remark = remark; }
        public List<Item> getItems() { return items; }
        public void setItems(List<Item> items) { this.items = items; }
    }

    public static class Item {
        private String bomCode;
        private String productMateriel;
        private Integer qty;
        private String planDeliveryDate;
        private String planStartDate;
        private Integer leadTimeDays;
        private BigDecimal targetCapacity;
        private String configuration;

        public String getBomCode() { return bomCode; }
        public void setBomCode(String bomCode) { this.bomCode = bomCode; }
        public String getProductMateriel() { return productMateriel; }
        public void setProductMateriel(String productMateriel) { this.productMateriel = productMateriel; }
        public Integer getQty() { return qty; }
        public void setQty(Integer qty) { this.qty = qty; }
        public String getPlanDeliveryDate() { return planDeliveryDate; }
        public void setPlanDeliveryDate(String planDeliveryDate) { this.planDeliveryDate = planDeliveryDate; }
        public String getPlanStartDate() { return planStartDate; }
        public void setPlanStartDate(String planStartDate) { this.planStartDate = planStartDate; }
        public Integer getLeadTimeDays() { return leadTimeDays; }
        public void setLeadTimeDays(Integer leadTimeDays) { this.leadTimeDays = leadTimeDays; }
        public BigDecimal getTargetCapacity() { return targetCapacity; }
        public void setTargetCapacity(BigDecimal targetCapacity) { this.targetCapacity = targetCapacity; }
        public String getConfiguration() { return configuration; }
        public void setConfiguration(String configuration) { this.configuration = configuration; }
    }
}
