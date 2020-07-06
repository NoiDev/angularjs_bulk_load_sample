'use strict;'

angular.module('appSample.bulkLoad').component 'bulkLoadControls', {
  controller: 'BulkLoadController'
  controllerAs: 'vm'
  templateUrl: 'app/bulk_load/bulk_load.html'
  bindings: {
    bulkLoadType: '@'
  }
}

angular.module('appSample.bulkLoad').component 'bulkLoadInstructionsPurchaseItems', {
  templateUrl: 'app/bulk_load/instructions_purchase_items.html'
}

angular.module('appSample.bulkLoad').component 'bulkLoadInstructionsBeginningCosts', {
  templateUrl: 'app/bulk_load/instructions_beginning_costs.html'
}

angular.module('appSample.bulkLoad').component 'bulkLoadInstructionsHousemadeItems', {
  templateUrl: 'app/bulk_load/instructions_housemade_items.html'
}


angular.module('appSample.bulkLoad').controller 'BulkLoadController',
  ($log, BulkLoadInventoryItemsJobsService) ->
    vm = @


    # Constants

    vm.BULK_LOAD_TYPE_PURCHASE_ITEMS = 'PURCHASE_ITEMS'
    vm.BULK_LOAD_TYPE_BEGINNING_COSTS = 'BEGINNING_COSTS'
    vm.BULK_LOAD_TYPE_HOUSEMADE_ITEMS = 'HOUSEMADE_ITEMS'


    # Data

    vm.file = undefined
    vm.itemsLoadedCount = 0
    vm.itemsCount = 0
    vm.itemsSkippedCount = 0


    # UI State

    vm.uploadComplete = false
    vm.showSpinner = false
    vm.verifyOnly = true
    vm.fileContentsLoadedToDatabase = false
    vm.isInstructionsShown = false
    vm.processingError = false


    vm.isBulkLoadType = (bulkLoadType) ->
      vm.bulkLoadType == bulkLoadType


    vm.isBulkLoadTypePurchaseItems = ->
      vm.isBulkLoadType(vm.BULK_LOAD_TYPE_PURCHASE_ITEMS)


    vm.isBulkLoadTypeBeginningCosts = ->
      vm.isBulkLoadType(vm.BULK_LOAD_TYPE_BEGINNING_COSTS)


    vm.isBulkLoadTypeHousemadeItems = ->
      vm.isBulkLoadType(vm.BULK_LOAD_TYPE_HOUSEMADE_ITEMS)


    vm.getUserFacingBulkLoadType = ->
      result = undefined
      if vm.isBulkLoadTypePurchaseItems()
        result = 'Purchase Items'
      else if vm.isBulkLoadTypeBeginningCosts()
        result = 'Beginning Costs'
      else if vm.isBulkLoadTypeHousemadeItems()
        result = 'Housemade Items'
      result


    vm.onSelectUploadFile = (file) ->
      # Note: file is stored as vm.file by ng-file-uplaod
      vm.fileContentsLoadedToDatabase = false
      vm.doUpload(file, vm.verifyOnly)


    vm.retryUploadFile = ->
      vm.doUpload(vm.file, vm.verifyOnly)


    vm.loadItemsFromCurrentFile = ->
      file = vm.file
      verify = false
      vm.doUpload(file, verify)


    vm.doUpload = (file, verify) ->
      vm.uploadStarted = true
      vm.uploadComplete = false
      vm.processingError = false

      if file
        filename = file.name
        success = (response) ->
          vm.showSpinner = false
          vm.uploadComplete = true
          vm.loadBulkLoadJobData(response.data)

          if !verify
            vm.fileContentsLoadedToDatabase = true
        failure = (response) ->
          vm.showSpinner = false
          vm.processingError = true
          vm.uploadComplete = true
          vm.loadBulkLoadJobData(response.data)

          $log.info "Error occurred.  Status: #{response.status}, Status text: #{response.statusText}"
        promise = BulkLoadInventoryItemsJobsService.uploadFile file, verify, vm.bulkLoadType
        promise.then success, failure


    vm.loadBulkLoadJobData = (bulkLoadJobData) ->
      vm.validationErrors = bulkLoadJobData.bulk_load_inventory_items_job_errors
      vm.itemsCount = bulkLoadJobData.total_items_count or 0
      vm.itemsLoadedCount = bulkLoadJobData.added_items_count or 0
      vm.itemsSkippedCount = bulkLoadJobData.skipped_items_count or 0


    vm.hideInstructions = ->
      vm.isInstructionsShown = false


    vm.showInstructions = ->
      vm.isInstructionsShown = true


    vm
