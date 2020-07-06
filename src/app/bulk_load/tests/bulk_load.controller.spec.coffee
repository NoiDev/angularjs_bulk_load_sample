'use strict'

describe 'Controller: BulkLoadController', ->
  beforeEach module 'appSample.bulkLoad'

  controllerFactory = undefined
  controller = undefined
  BulkLoadInventoryItemsJobsService = undefined
  $log = undefined
  promise = undefined

  beforeEach inject (
    _$controller_,
    _BulkLoadInventoryItemsJobsService_,
    _ToastsService_,
    $rootScope,
    _$log_
  ) ->
    $log = _$log_
    $rootScope.current_user = {serviceProviderId: 2}
    controllerFactory = _$controller_
    BulkLoadInventoryItemsJobsService = _BulkLoadInventoryItemsJobsService_
    promise = new appSample.q.Mock
    makeController()

  makeController = ->
    controller = controllerFactory 'BulkLoadController', {
      $log: $log
      BulkLoadInventoryItemsJobsService: BulkLoadInventoryItemsJobsService
    }

  describe 'controller construction', ->
    it 'should set .file to undefined', ->
      expect(controller.file).toBeUndefined()

    it 'should set .verifyOnly to true', ->
      expect(controller.verifyOnly).toBeTruthy()

    it 'should set .uploadComplete to false', ->
      expect(controller.uploadComplete).toBeFalsy()

    it 'should set .showSpinner to false', ->
      expect(controller.showSpinner).toBeFalsy()

    it 'should set .itemsLoadedCount to zero', ->
      expect(controller.itemsLoadedCount).toBe 0

    it 'should set .itemsCount to zero', ->
      expect(controller.itemsCount).toBe 0

    it 'should set .itemsSkippedCount to zero', ->
      expect(controller.itemsSkippedCount).toBe 0

    it 'should set .isInstructionsShown to false', ->
      expect(controller.isInstructionsShown).toBeFalsy()


  describe '.isBulkLoadType', ->
    beforeEach ->
      controller.bulkLoadType = controller.BULK_LOAD_TYPE_PURCHASE_ITEMS

    describe 'when the types match', ->
      it 'returns true', ->
        actual = controller.isBulkLoadType(controller.BULK_LOAD_TYPE_PURCHASE_ITEMS)
        expect(actual).toBeTruthy()

    describe 'when the types do NOT match', ->
      it 'returns false', ->
        actual = controller.isBulkLoadType(controller.BULK_LOAD_TYPE_HOUSEMADE_ITEMS)
        expect(actual).toBeFalsy()


  describe '.isBulkLoadTypePurchaseItems', ->
    actual = undefined

    describe 'when the types match', ->
      beforeEach ->
        spyOn(controller, 'isBulkLoadType').and.returnValue true
        actual = controller.isBulkLoadTypePurchaseItems()

      it 'calls .isBulkLoadType', ->
        expect(controller.isBulkLoadType).toHaveBeenCalledWith(controller.BULK_LOAD_TYPE_PURCHASE_ITEMS)

      it 'returns true', ->
        expect(actual).toBeTruthy()

    describe 'when the types do NOT match', ->
      beforeEach ->
        spyOn(controller, 'isBulkLoadType').and.returnValue false
        actual = controller.isBulkLoadTypePurchaseItems()

      it 'calls .isBulkLoadType', ->
        expect(controller.isBulkLoadType).toHaveBeenCalledWith(controller.BULK_LOAD_TYPE_PURCHASE_ITEMS)

      it 'returns false', ->
        expect(actual).toBeFalsy()


  describe '.isBulkLoadTypeBeginningCosts', ->
    actual = undefined

    describe 'when the types match', ->
      beforeEach ->
        spyOn(controller, 'isBulkLoadType').and.returnValue true
        actual = controller.isBulkLoadTypeBeginningCosts()

      it 'calls .isBulkLoadType', ->
        expect(controller.isBulkLoadType).toHaveBeenCalledWith(controller.BULK_LOAD_TYPE_BEGINNING_COSTS)

      it 'returns true', ->
        expect(actual).toBeTruthy()

    describe 'when the types do NOT match', ->
      beforeEach ->
        spyOn(controller, 'isBulkLoadType').and.returnValue false
        actual = controller.isBulkLoadTypeBeginningCosts()

      it 'calls .isBulkLoadType', ->
        expect(controller.isBulkLoadType).toHaveBeenCalledWith(controller.BULK_LOAD_TYPE_BEGINNING_COSTS)

      it 'returns false', ->
        expect(actual).toBeFalsy()


  describe '.isBulkLoadTypeHousemadeItems', ->
    actual = undefined

    describe 'when the types match', ->
      beforeEach ->
        spyOn(controller, 'isBulkLoadType').and.returnValue true
        actual = controller.isBulkLoadTypeHousemadeItems()

      it 'calls .isBulkLoadType', ->
        expect(controller.isBulkLoadType).toHaveBeenCalledWith(controller.BULK_LOAD_TYPE_HOUSEMADE_ITEMS)

      it 'returns true', ->
        expect(actual).toBeTruthy()

    describe 'when the types do NOT match', ->
      beforeEach ->
        spyOn(controller, 'isBulkLoadType').and.returnValue false
        actual = controller.isBulkLoadTypeHousemadeItems()

      it 'calls .isBulkLoadType', ->
        expect(controller.isBulkLoadType).toHaveBeenCalledWith(controller.BULK_LOAD_TYPE_HOUSEMADE_ITEMS)

      it 'returns false', ->
        expect(actual).toBeFalsy()


  describe '.onSelectUploadFile', ->
    file = {name: 'Myfile.xlsx'}

    beforeEach ->
      spyOn(controller, 'doUpload')
      controller.fileContentsLoadedToDatabase = true

    describe 'when .verifyOnly is set', ->
      beforeEach ->
        controller.verifyOnly = true
        controller.onSelectUploadFile file

      it 'unsets flag .fileContentsLoadedToDatabase', ->
        expect(controller.fileContentsLoadedToDatabase).toBeFalsy()

      it 'calls .doUpload', ->
        expect(controller.doUpload).toHaveBeenCalledWith(file, true)

    describe 'when .verifyOnly is NOT set', ->
      beforeEach ->
        controller.verifyOnly = false
        controller.onSelectUploadFile file

      it 'unsets flag .fileContentsLoadedToDatabase', ->
        expect(controller.fileContentsLoadedToDatabase).toBeFalsy()

      it 'calls .doUpload', ->
        expect(controller.doUpload).toHaveBeenCalledWith(file, false)


  describe '.retryUploadFile', ->
    file = {name: 'Myfile.xlsx'}

    beforeEach ->
      spyOn(controller, 'doUpload')
      controller.file = file

    describe 'when .verifyOnly is set', ->
      beforeEach ->
        controller.verifyOnly = true
        controller.retryUploadFile()

      it 'calls .doUpload', ->
        expect(controller.doUpload).toHaveBeenCalledWith(file, true)

    describe 'when .verifyOnly is NOT set', ->
      beforeEach ->
        controller.verifyOnly = false
        controller.retryUploadFile()

      it 'calls .doUpload', ->
        expect(controller.doUpload).toHaveBeenCalledWith(file, false)


  describe '.loadItemsFromCurrentFile', ->
    file = {name: 'Myfile.xlsx'}

    beforeEach ->
      spyOn(controller, 'doUpload')
      controller.file = file

    describe 'when .verifyOnly is set', ->
      beforeEach ->
        controller.verifyOnly = true
        controller.loadItemsFromCurrentFile()

      it 'calls .doUpload, ignoring .verifyOnly', ->
        expect(controller.doUpload).toHaveBeenCalledWith(file, false)

    describe 'when .verifyOnly is NOT set', ->
      beforeEach ->
        controller.verifyOnly = false
        controller.loadItemsFromCurrentFile()

      it 'calls .doUpload, ignoring .verifyOnly', ->
        expect(controller.doUpload).toHaveBeenCalledWith(file, false)


  describe '.doUpload', ->
    file = {name: 'Myfile.xlsx'}

    beforeEach ->
      spyOn(BulkLoadInventoryItemsJobsService, 'uploadFile').and.returnValue promise
      spyOn(controller, 'loadBulkLoadJobData')
      controller.bulkLoadType = controller.BULK_LOAD_TYPE_PURCHASE_ITEMS
      controller.uploadStarted = false
      controller.uploadComplete = true
      controller.processingError = true

    describe 'when uploading', ->
      verifyOnly = false

      beforeEach ->
        controller.doUpload file, verifyOnly

      it 'should set .uploadStarted to true', ->
        expect(controller.uploadStarted).toBeTruthy()

      it 'should set .uploadComplete to false', ->
        expect(controller.uploadComplete).toBeFalsy()

      it 'should set .processingError to false', ->
        expect(controller.processingError).toBeFalsy()

      it 'should invoke BulkLoadInventoryItemsJobsService.uploadFile function', ->
        expect(BulkLoadInventoryItemsJobsService.uploadFile).toHaveBeenCalledWith file, verifyOnly, controller.bulkLoadType

      describe 'when the promise resolves', ->
        response = {data: {}}

        beforeEach ->
          controller.uploadComplete = false
          controller.fileContentsLoadedToDatabase = false
          promise.resolve response

        it 'should set .uploadComplete to true', ->
          expect(controller.uploadComplete).toBeTruthy()

        it 'should set .fileContentsLoadedToDatabase to true', ->
          expect(controller.fileContentsLoadedToDatabase).toBeTruthy()

        it 'should invoke .loadBulkLoadJobData', ->
          expect(controller.loadBulkLoadJobData).toHaveBeenCalledWith response.data

      describe 'when the promise rejects', ->
        response = {
          status: 500
          statusText: 'Not good Bob!'
          data: {}
        }

        beforeEach ->
          controller.processingError = false
          promise.reject response

        it 'should set .processingError to true', ->
          expect(controller.processingError).toBeTruthy()

        it 'should set .uploadComplete to true', ->
          expect(controller.uploadComplete).toBeTruthy()

        it 'should invoke .loadBulkLoadJobData', ->
          expect(controller.loadBulkLoadJobData).toHaveBeenCalledWith response.data


    describe 'when verifying only', ->
      verifyOnly = true

      beforeEach ->
        controller.doUpload file, verifyOnly

      it 'should set .uploadStarted to true', ->
        expect(controller.uploadStarted).toBeTruthy()

      it 'should set .uploadComplete to false', ->
        expect(controller.uploadComplete).toBeFalsy()

      it 'should set .processingError to false', ->
        expect(controller.processingError).toBeFalsy()

      it 'should invoke BulkLoadInventoryItemsJobsService.uploadFile function', ->
        expect(BulkLoadInventoryItemsJobsService.uploadFile).toHaveBeenCalledWith file, verifyOnly, controller.bulkLoadType

      describe 'when the promise resolves', ->
        response = {data: {}}

        beforeEach ->
          controller.uploadComplete = false
          controller.fileContentsLoadedToDatabase = false
          promise.resolve response

        it 'should set .uploadComplete to true', ->
          expect(controller.uploadComplete).toBeTruthy()

        it 'should leave .fileContentsLoadedToDatabase as false', ->
          expect(controller.fileContentsLoadedToDatabase).toBeFalsy()

      describe 'when the promise rejects', ->
        response = {
          status: 500
          statusText: 'Not good Bob!'
          data: {}
        }

        beforeEach ->
          promise.reject response

        it 'should invoke .loadBulkLoadJobData', ->
          expect(controller.loadBulkLoadJobData).toHaveBeenCalledWith response.data


  describe '.loadBulkLoadJobData', ->
    bulkLoadJobData = {
      total_items_count: 889
      added_items_count: 788
      skipped_items_count: 101
      bulk_load_inventory_items_job_errors: [{}, {}]
    }

    beforeEach ->
      controller.loadBulkLoadJobData bulkLoadJobData

    it 'should set controller.itemsCount', ->
      expect(controller.itemsCount).toEqual bulkLoadJobData['total_items_count']

    it 'should set controller.itemsLoadedCount', ->
      expect(controller.itemsLoadedCount).toEqual bulkLoadJobData['added_items_count']

    it 'should set controller.itemsSkippedCount', ->
      expect(controller.itemsSkippedCount).toEqual bulkLoadJobData['skipped_items_count']

    it 'should set controller.validationErrors', ->
      expect(controller.validationErrors).toEqual bulkLoadJobData['bulk_load_inventory_items_job_errors']


  describe '.hideInstructions', ->
    beforeEach ->
      controller.isInstructionsShown = true
      controller.hideInstructions()

    it 'should set controller.isInstructionsShown to false', ->
      expect(controller.isInstructionsShown).toBeFalsy()


  describe '.showInstructions', ->
    beforeEach ->
      controller.isInstructionsShown = false
      controller.showInstructions()

    it 'should set controller.isInstructionsShown to true', ->
      expect(controller.isInstructionsShown).toBeTruthy()
