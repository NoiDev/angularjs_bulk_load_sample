angular.module 'appSample.housemadeItems'
.config ($stateProvider) ->
  $stateProvider
  .state "housemadeItems",
    # REDACTED
  .state "housemadeItems.bulk",
    url: "/bulk/load"
    views:
      '@':
        templateUrl: "app/items/housemade/bulk_load/items_bulk_load.html"
    ncyBreadcrumb:
      label: "Bulk Load"
