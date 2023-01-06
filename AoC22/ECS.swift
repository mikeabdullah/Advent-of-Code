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
    let index = component.entity.rawValue
    let table = componentTables[index] as! ComponentTable<C>
    return table.map
  }
  
  // MARK: Component Registration
  
  struct ComponentRegistration<C> where C: Component {
    
    let entity: Entity
  }
  
  private var registeredComponents = [Component.Type]()
  
  /// Explicitly register a component.
  func registerComponent<C>(_ componentType: C.Type) -> ComponentRegistration<C> where C : Component {
    precondition(registeredComponents.endIndex <= 64, "Maximum components exceeded")
    let entity = Entity(rawValue: registeredComponents.endIndex)
    registeredComponents.append(componentType)
    componentTables.append(ComponentTable<C>())
    return ComponentRegistration(entity: entity)
  }
  
  // MARK: Accessing Components
  
  private var componentTables: [AnyObject] = []
  
  subscript<C: Component>(component: ComponentRegistration<C>, for entity: Entity) -> C? {
    get {
      let table = componentTables[component.entity.rawValue] as! ComponentTable<C>
      return table.map[entity]
    }
    set {
      let index = component.entity.rawValue
      let table = componentTables[index] as! ComponentTable<C>
      table.map[entity] = newValue
    }
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
