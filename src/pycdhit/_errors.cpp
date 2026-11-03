#include <Python.h>

#include <cdhit-common.h>

void bomb_error(const char *message)
{
    PyGILState_STATE py = PyGILState_Ensure();
    PyErr_SetString(PyExc_RuntimeError, message);
    PyGILState_Release(py);
    throw std::runtime_error(message);
} // END void bomb_error

void bomb_error(const char *message, const char *message2)
{
    PyGILState_STATE py = PyGILState_Ensure();
    PyErr_Format(PyExc_RuntimeError, "%s %s", message, message2);
    PyGILState_Release(py);
    throw std::runtime_error(message);
} // END void bomb_error


void bomb_warning(const char *message)
{
    PyGILState_STATE py = PyGILState_Ensure();
    PyErr_WarnEx(PyExc_RuntimeWarning, message, 1);
    PyGILState_Release(py);
} // END void bomb_warning


void bomb_warning(const char *message, const char *message2)
{
    PyGILState_STATE py = PyGILState_Ensure();
    PyErr_WarnFormat(PyExc_RuntimeWarning, 1, "%s %s", message, message2);
    PyGILState_Release(py);
} // END void bomb_warning