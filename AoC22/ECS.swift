//
//  ECS.swift
//  AoC
//
//  Created by Mike on 03/01/2023.
//

final class World {
  
  // MARK: Entities
  
  /// Leave some space for components as the starting point.
  private var lastEntityId = 64
  
  func create() -> Entity {
    lastEntityId += 1
    return Entity(rawValue: lastEntityId)
  }
  
  /// Queries for all entities that have a given component type.
  func entities<C>(thatHave componentType: C.Type) -> [Entity: C] where C : Component {
    let index = registerComponentIfNeeded(C.self).rawValue
    let table = componentTables[index] as! ComponentTable<C>
    return table.map
  }
  
  // MARK: Component Registration
  
  typealias RegisteredComponent = Entity
  
  private var registeredComponents = [Component.Type]()
  
  /// Explicitly register a component.
  func registerComponent<C>(_ componentType: C.Type) -> RegisteredComponent where C : Component {
    precondition(registeredComponents.endIndex <= 64, "Maximum components exceeded")
    let entity = Entity(rawValue: registeredComponents.endIndex)
    registeredComponents.append(componentType)
    componentTables.append(ComponentTable<C>())
    return entity
  }
  
  /// Looks up the index/entity a component type has been registered for.
  /// - Complexity: O(n) where _n_ is number of registered components.
  func registration(for componentType: Component.Type) -> RegisteredComponent? {
    guard let index = registeredComponents.firstIndex(where: { $0 == componentType }) else {
      return nil
    }
    return RegisteredComponent(rawValue: index)
  }
  
  func registerComponentIfNeeded(_ componentType: Component.Type) -> RegisteredComponent {
    return registration(for: componentType) ?? registerComponent(componentType)
  }
  
  // MARK: Accessing Components
  
  private var componentTables: [AnyObject] = []
  
  func get<C>(_ componentType: C.Type, for entity: Entity) -> C? where C : Component {
    let index = registerComponentIfNeeded(componentType).rawValue
    let table = componentTables[index] as! ComponentTable<C>
    return table.map[entity]
  }
  
  func set<C>(_ component: C?, for entity: Entity) where C : Component {
    let index = registerComponentIfNeeded(C.self).rawValue
    let table = componentTables[index] as! ComponentTable<C>
    table.map[entity] = component
  }
  
  /// Simple mapping of components stored per entity.
  private final class ComponentTable<C> where C: Component {
    
    var map = [Entity: C]()
  }
}

struct Entity: RawRepresentable, Hashable {
  let rawValue: Int
}

protocol Component { }
