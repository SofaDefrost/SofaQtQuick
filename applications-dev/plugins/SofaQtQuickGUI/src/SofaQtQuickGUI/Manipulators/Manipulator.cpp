#include "Manipulator.h"

namespace sofaqtquick
{

Manipulator::Manipulator(QObject* parent)
    : QObject(parent),
      m_particleIndex(-1),
      m_isEditMode(false),
      m_persistent(false),
      m_enabled(false)
{

}

const QString& Manipulator::getName()
{
    return m_name;
}

void Manipulator::setName(const QString& name)
{
    m_name = name;
}

int Manipulator::getIndex()
{
    return m_index;
}

void Manipulator::setIndex(int index)
{
    m_index = index;
}

void Manipulator::setParticleIndex(int idx)
{
    m_particleIndex = idx;
}

int Manipulator::getParticleIndex()
{
    return m_particleIndex;
}

bool Manipulator::isEditMode()
{
    return m_isEditMode;
}

void Manipulator::toggleEditMode(bool val)
{
    m_isEditMode = val;
}


void Manipulator::draw(const SofaViewer& viewer)
{
    int idx = -1;
    if (m_enabled) {
        internalDraw(viewer, idx);
    }
}

void Manipulator::pick(const SofaViewer& viewer, int& pickIndex)
{
    if (m_enabled)
        internalDraw(viewer, pickIndex, true);
}

}  // namespace sofaqtquick
