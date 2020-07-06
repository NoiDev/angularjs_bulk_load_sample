'use strict'

angular.module('appSample.core').factory 'BulkLoadInventoryItemsJobsService', (Restangular, Upload) ->
  new class BulkLoadInventoryItemsJobsService
    BULK_LOAD_INVENTORY_ITEMS_JOBS_RESOURCE: 'bulk_load_inventory_items_jobs'

    BULK_LOAD_TYPE_PURCHASE_ITEMS: 'PURCHASE_ITEMS'
    BULK_LOAD_TYPE_BEGINNING_COSTS: 'BEGINNING_COSTS'
    BULK_LOAD_TYPE_HOUSEMADE_ITEMS: 'HOUSEMADE_ITEMS'

    get: (id) ->
      Restangular.one(@BULK_LOAD_INVENTORY_ITEMS_JOBS_RESOURCE, id).get()

    uploadFile: (file, shouldOnlyVerify, bulkLoadType) ->
      data = {
        file: file
        verify_only: shouldOnlyVerify
      }

      if bulkLoadType == @BULK_LOAD_TYPE_PURCHASE_ITEMS
        # Do Nothing
      else if bulkLoadType == @BULK_LOAD_TYPE_BEGINNING_COSTS
        data.costs = true
      else if bulkLoadType == @BULK_LOAD_TYPE_HOUSEMADE_ITEMS
        data.housemade = true

      uploadUrl = "/api/#{@BULK_LOAD_INVENTORY_ITEMS_JOBS_RESOURCE}"

      promise = Upload.upload {url: uploadUrl, data: data}
      promise
