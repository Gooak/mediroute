//
//  DIContainer.swift
//  mediroute
//
//  Created by 황진우 on 11/15/25.
//
import SwiftData

final class DIContainer {

    static let Di = DIContainer()

    private init() {}

    // MARK: - DataSource
    lazy var geminiRemoteDataSource: GeminiRemoteDataSource = GeminiRemoteDataSourceImpl()
    lazy var openApiDataSource: OpenApiDataSource = OpenApiDataSourceImpl()

    // MARK: - Repository
    lazy var geminiRepository: GeminiRepository = GeminiRepositoryImpl(dataSource: geminiRemoteDataSource)
    lazy var openApiRepository: OpenApiRepository = OpenApiRepositoryImpl(dataSource: openApiDataSource)

    // MARK: - UseCase
    lazy var geminiUseCase: GeminiUseCase = GeminiUseCase(repository: geminiRepository)
    lazy var openApiUseCase: OpenApiUseCase = OpenApiUseCase(repository: openApiRepository)
    lazy var locationUseCase: LocationUseCase = LocationUseCase()
}
