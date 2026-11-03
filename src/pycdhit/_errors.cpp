#include <Python.h>

#include <cdhit-common.h>

void bomb_error(const char *message)
{
    PyErr_SetString(PyExc_RuntimeError, message);
    throw std::runtime_error(message);
} // END void bomb_error

void bomb_error(const char *message, const char *message2)
{
    PyErr_Format(PyExc_RuntimeError, "%s %s", message, message2);
    throw std::runtime_error(message);
} // END void bomb_error


void bomb_warning(const char *message)
{
    PyErr_Warn(PyExc_RuntimeWarning, message);
} // END void bomb_warning


void bomb_warning(const char *message, const char *message2)
{
    PyErr_WarnFormat(PyExc_RuntimeWarning, 1, "%s %s", message, message2);
} // END void bomb_warning