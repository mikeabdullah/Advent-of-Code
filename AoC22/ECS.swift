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
  func entities<C>(thatHave component: ComponentRegistration<C>) -> [Entity: C] where C : Component {
    return component.table
  }
  
  // MARK: Component Registration
  
  class ComponentRegistration<C> where C: Component {
    
    fileprivate init(entity: Entity) {
      self.entity = entity
    }
    
    fileprivate let entity: Entity
    
    /// Simple mapping of components stored per entity.
    fileprivate var table = [Entity: C]()
  }
  
  /// Explicitly register a component.
  func registerComponent<C>(_ componentType: C.Type) -> ComponentRegistration<C> where C : Component {
    precondition(registeredComponents.endIndex <= 64, "Maximum components exceeded")
    let registration = ComponentRegistration<C>(entity: Entity(rawValue: registeredComponents.endIndex))
    registeredComponents.append(registration)
    return registration
  }
  
  // MARK: Accessing Components
  
  private var registeredComponents: [AnyObject] = []
  
  subscript<C: Component>(component: ComponentRegistration<C>, for entity: Entity) -> C? {
    get {
      return component.table[entity]
    }
    set {
      component.table[entity] = newValue
    }
  }
}

struct Entity: RawRepresentable, Hashable {
  let rawValue: Int
}

protocol Component { }
