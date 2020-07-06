'use strict'

describe 'Service: BulkLoadInventoryItemsJobsService', ->
  beforeEach module 'appSample'

  BulkLoadInventoryItemsJobsService = undefined
  Restangular = undefined
  Upload = undefined
  restangularizedObject = undefined
  promise = undefined

  beforeEach inject (_BulkLoadInventoryItemsJobsService_, _Restangular_, _Upload_) ->
    BulkLoadInventoryItemsJobsService = _BulkLoadInventoryItemsJobsService_
    Restangular = _Restangular_
    Upload = _Upload_
    promise = new appSample.q.Mock

  describe '.get', ->
    expectedId = 12342
    actual = undefined

    beforeEach ->
      restangularizedObject = {get: ->}
      spyOn(Restangular, 'one').and.returnValue restangularizedObject
      spyOn(restangularizedObject, 'get').and.returnValue promise
      actual = BulkLoadInventoryItemsJobsService.get expectedId

    it 'retrieve a single job by ID', ->
      expect(Restangular.one).toHaveBeenCalledWith(
        BulkLoadInventoryItemsJobsService.BULK_LOAD_INVENTORY_ITEMS_JOBS_RESOURCE, expectedId)
      expect(restangularizedObject.get).toHaveBeenCalled()

    it 'should return a promise', ->
      expect(actual).toBe promise


  describe '.uploadFile', ->
    file = {}
    shouldVerifyOnly = false
    bulkLoadType = undefined
    actual = undefined
    uploadUrl = '/api/bulk_load_inventory_items_jobs'

    beforeEach ->
      spyOn(Upload, 'upload').and.returnValue promise

    describe 'when uploading purchase items', ->
      beforeEach ->
        bulkLoadType = BulkLoadInventoryItemsJobsService.BULK_LOAD_TYPE_PURCHASE_ITEMS
        actual = BulkLoadInventoryItemsJobsService.uploadFile(
          file, shouldVerifyOnly, bulkLoadType)

      it 'should invoke Upload.upload function', ->
        data = {
          file: file
          verify_only: shouldVerifyOnly
        }
        expect(Upload.upload).toHaveBeenCalledWith {url: uploadUrl, data: data}

      it 'should return a promise', ->
        expect(actual).toBe promise

    describe 'when uploading beginning costs', ->
      beforeEach ->
        bulkLoadType = BulkLoadInventoryItemsJobsService.BULK_LOAD_TYPE_BEGINNING_COSTS
        actual = BulkLoadInventoryItemsJobsService.uploadFile(
          file, shouldVerifyOnly, bulkLoadType)

      it 'should invoke Upload.upload function', ->
        data = {
          file: file
          verify_only: shouldVerifyOnly
          costs: true
        }
        expect(Upload.upload).toHaveBeenCalledWith {url: uploadUrl, data: data}

      it 'should return a promise', ->
        expect(actual).toBe promise

    describe 'when uploading housemade items', ->
      beforeEach ->
        bulkLoadType = BulkLoadInventoryItemsJobsService.BULK_LOAD_TYPE_HOUSEMADE_ITEMS
        actual = BulkLoadInventoryItemsJobsService.uploadFile(
          file, shouldVerifyOnly, bulkLoadType)

      it 'should invoke Upload.upload function', ->
        data = {
          file: file
          verify_only: shouldVerifyOnly
          housemade: true
        }
        expect(Upload.upload).toHaveBeenCalledWith {url: uploadUrl, data: data}

      it 'should return a promise', ->
        expect(actual).toBe promise
