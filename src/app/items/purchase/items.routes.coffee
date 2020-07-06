angular.module 'appSample.purchaseItems'
.config ($stateProvider) ->
  $stateProvider
  .state "purchaseItems",
    # REDACTED
  .state "purchaseItems.bulk",
    url: "/bulk/load"
    views:
      '@':
        templateUrl: "app/items/purchase/bulk_load/items_bulk_load.html"
    ncyBreadcrumb:
      label: "Bulk Load"
