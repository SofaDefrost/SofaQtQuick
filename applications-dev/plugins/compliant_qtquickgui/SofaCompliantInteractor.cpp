/*
Copyright 2015, Anatoscope

This file is part of sofaqtquick.

sofaqtquick is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

sofaqtquick is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with sofaqtquick. If not, see <http://www.gnu.org/licenses/>.
*/

#include "SofaCompliantInteractor.h"
#include <SofaQtQuickGUI/SofaScene.h>
// #include "SofaViewer.h"
// #include "Manipulator.h"

#include <sofa/core/visual/VisualParams.h>
#include <sofa/core/visual/VisualModel.h>
#include <sofa/core/behavior/MechanicalState.h>
#include <sofa/simulation/MechanicalVisitor.h>
#include <sofa/simulation/CleanupVisitor.h>
#include <sofa/simulation/DeleteVisitor.h>
#include <SofaBaseMechanics/MechanicalObject.h>
#include <SofaBoundaryCondition/FixedConstraint.h>
#include <SofaRigid/JointSpringForceField.h>
#include <SofaBaseVisual/VisualStyle.h>
#include <sofa/helper/cast.h>


#include <Compliant/mapping/DifferenceFromTargetMapping.h>
#include <Compliant/compliance/UniformCompliance.h>

#include <typeindex>

#include <qqml.h>
#include <QDebug>

namespace sofa
{

typedef sofa::simulation::Node Node;

namespace qtquick
{

using namespace sofa::defaulttype;
using namespace sofa::core::behavior;
using namespace sofa::component::container;
using namespace sofa::component::projectiveconstraintset;
using namespace sofa::component::interactionforcefield;

SofaCompliantInteractor::SofaCompliantInteractor(QObject *parent)
    : QObject(parent),
      compliance(1)
{
	
}

SofaCompliantInteractor::~SofaCompliantInteractor()
{
    
}

template<class Types>
std::function< bool(const QVector3D&) > SofaCompliantInteractor::update_thunk(SofaComponent* component,
									      int index) {
    
    using state_type = MechanicalObject<Types>;

    // interactor dofs
    auto state = dynamic_cast<state_type*>(component->base());
    assert(state && "bad state type in interactor thunk");
    
    using namespace component;
    using core::objectmodel::New;
    using helper::write;
    
    // difference dofs
    auto dofs = New<container::MechanicalObject<Types>>();
    
    // difference mapping
    auto mapping = New<mapping::DifferenceFromTargetMapping<Types, Types>>();
    mapping->setFrom(state);
    mapping->setTo(dofs.get());

    write(mapping->indices).wref().resize(1);
    write(mapping->indices).wref()[0] = index;
    
    write(mapping->targets).wref().resize(1);
    write(mapping->targets).wref()[0] = write(state->x).wref()[index];
    
    // forcefield on difference
    auto ff = New<forcefield::UniformCompliance<Types>>();
    
    ff->compliance.setValue(compliance);
    ff->damping.setValue(1.0 / (1.0 + compliance) );

    // display flags
    auto style = New<visualmodel::VisualStyle>();
    helper::write(style->displayFlags).wref().setShowMechanicalMappings(true);
    
    // node setup
    node = component->sofaScene()->sofaRootNode()->createChild("Interactor");
    
    node->addObject(dofs);
    node->addObject(mapping);
    node->addObject(ff);
    node->addObject(style);
    
    node->init( core::ExecParams::defaultInstance() );

    // interactor position update
    position = QVector3D(state->getPX(index), 
			 state->getPY(index),
			 state->getPZ(index));
    
    return [mapping,this](const QVector3D& pos) -> bool {
	
	position = pos;
	write(mapping->targets).wref()[0] = {pos.x(), pos.y(), pos.z()};
	
	return true;
    };
}

bool SofaCompliantInteractor::start(SofaComponent* sofaComponent, int particleIndex)
{

    using thunk_type = update_cb_type (SofaCompliantInteractor::*)(SofaComponent* component,
								   int index);

    // double dispatch table
    // TODO rigid interactors and friends
    static std::map< std::type_index, thunk_type> dispatch {
	{std::type_index(typeid(MechanicalObject<Vec3dTypes>)), &SofaCompliantInteractor::update_thunk<Vec3dTypes>},
	{std::type_index(typeid(MechanicalObject<Vec3fTypes>)), &SofaCompliantInteractor::update_thunk<Vec3fTypes>}
    };
    
    std::type_index key = typeid(*sofaComponent->base());
    auto it = dispatch.find(key);

    if(it == dispatch.end()) {
	return false;
    }

    update_cb = (this->*it->second)(sofaComponent, particleIndex);
    return true;
}

bool SofaCompliantInteractor::update(const QVector3D& position)
{
    if(update_cb) return update_cb(position);
    else return false;
}

bool SofaCompliantInteractor::interacting() const {
    return bool(update_cb);
}
    
void SofaCompliantInteractor::release()
{
    // std::clog << "release" << std::endl;
    update_cb = 0;

    if( node ) {
	node->detachFromGraph();
	node = 0;
    }
}




}

}