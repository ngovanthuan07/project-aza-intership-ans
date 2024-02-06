export let generateNumberArray = (min, max) => {
    return Array.from({ length: max - min + 1 }, (_, index) => index + min);
}

export const handListPageFull = (minPage, maxPage, currentPage, pages = 7) => {
   let allPageNumber = generateNumberArray(minPage, maxPage)
   let scopeFirst = allPageNumber.slice(0, 5);
   let scopeLast = allPageNumber.slice(-5);
   if(maxPage <= pages) {
    return allPageNumber
   }
   if(scopeFirst.includes(currentPage) && currentPage !== scopeFirst[scopeFirst.length - 1]) {
    return [...scopeFirst, -1,...allPageNumber.slice(-1)]
   }
   if(scopeLast.includes(currentPage) && currentPage !== scopeLast[0]) {
    return [...scopeFirst.slice(0, 1), -1,...allPageNumber.slice(-5)]
   }

   let backCurrentPage = currentPage - 1
   let forwardCurrentPage = currentPage + 1
   return [...scopeFirst.slice(0, 1), -1, backCurrentPage, currentPage, forwardCurrentPage,-1,  ...scopeLast.splice(-1)]
}

export const handListPage = (minPage, maxPage, currentPage, firstPage) => {
    if(minPage === maxPage) {
        return [minPage]
    }
    if(minPage === maxPage - 1) {
        return [minPage, maxPage]
    }
    if(firstPage) {
        return [minPage, minPage + 1, minPage + 2]
    }
    if(currentPage === minPage) {
        return [minPage, -1, maxPage]
    }
    if(currentPage === maxPage) {
        return [ maxPage -2, maxPage -1, maxPage]
    }

    return [currentPage - 1, currentPage, currentPage + 1]
}

