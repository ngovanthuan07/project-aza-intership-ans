export default {
    namespaced: true,
    state: {
      minPageItem: 1,
      maxPageItem: 31,
      currentPage: 1
    },
    mutations: {
      SET_MIN_PAGE_ITEM(state, payload) {
        state.minPageItem = payload
      },
      SET_MAX_PAGE_ITEM(state, payload) {
        state.maxPageItem = payload
      },
      SET_CURRENT_PAGE(state, payload) {
        state.currentPage = payload
      }
    },
    actions: {
      onChangeMinPageItem(context, payload) {
        let minP = context.state.minPageItem
        minP = payload
        context.commit('SET_MIN_PAGE_ITEM', minP)
      },
      onChangeMaxPageItem(context, payload) {
        let maxP = context.state.maxPageItem
        maxP = payload
        context.commit('SET_MAX_PAGE_ITEM', maxP)
      },
      onChangeCurrentPage(context, payload) {
        let currentP = context.state.currentPage
        currentP = payload
        context.commit('SET_CURRENT_PAGE', currentP)
      }
    },
    getters: {
      maxPageItem: function (state) {
        return  state.maxPageItem
      },
      minPageItem: function (state) {
        return  state.minPageItem
      }, 
      currentPage: function (state) {
        return  state.currentPage
      }
    }
  }