/** @file dart_communication_priv.h
 *  @date 25 Aug 2014
 *  @brief Definition of dart_handle_struct
 */
#ifndef DART_ADAPT_COMMUNICATION_PRIV_H_INCLUDED
#define DART_ADAPT_COMMUNICATION_PRIV_H_INCLUDED

#include <stdio.h>
#include <mpi.h>
#include <dash/dart/if/dart_types.h>
#include <dash/dart/if/dart_communication.h>

#ifdef SHMEM_ENABLE
#ifdef PROGRESS_ENABLE
#define PROGRESS_NUM 2
#define PROGRESS_UNIT 0
#define MEMFREE 0
#define EXIT 1
#define TEAMCREATE 2
#define MEMALLOC 3
#define PUT 4
#define GET 5
#define TEAMDESTROY 6
#define WAIT 7
#endif
#endif

/** @brief Dart handle type for non-blocking one-sided operations.
 */
#ifdef SHAREDMEM_ENABLE
#ifdef PROGRESS_ENABLE
struct dart_handle_struct
{
	MPI_Request request;
};

struct datastruct
{
	int32_t	    dest;
	uint16_t    index;
	MPI_Aint    orgin_offset;
	MPI_Aint    target_offset;
	int         dart_size;
	int16_t     segid;
	short       is_sharedmem;
};

extern MPI_Datatype data_info_type;
extern MPI_Comm     user_comm_world;
extern int          top;
#endif
#else
struct dart_handle_struct
{
	MPI_Request request;
	MPI_Win	    win;
	dart_unit_t dest;
};
#endif
MPI_Op dart_mpi_op(dart_operation_t dart_op) {
  switch(dart_op) {
  case DART_OP_MIN:  return MPI_MIN;
  case DART_OP_MAX:  return MPI_MAX;
  case DART_OP_SUM:  return MPI_SUM;
  case DART_OP_PROD: return MPI_PROD;
  case DART_OP_BAND: return MPI_BAND;
  case DART_OP_LAND: return MPI_LAND;
  case DART_OP_BOR:  return MPI_BOR;
  case DART_OP_LOR:  return MPI_LOR;
  case DART_OP_BXOR: return MPI_BXOR;
  case DART_OP_LXOR: return MPI_LXOR;
  }
}

#endif /* DART_ADAPT_COMMUNICATION_PRIV_H_INCLUDED */
