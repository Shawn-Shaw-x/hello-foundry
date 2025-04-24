import { Transfer as TransferEvent } from "../generated/ShawnERC20/ShawnERC20"
import { Transfer } from "../generated/schema"

export function handleTransfer(event: TransferEvent): void {
  let entity = new Transfer(event.transaction.hash.toHex() + "-" + event.logIndex.toString())
  entity.from = event.params.from
  entity.to = event.params.to
  entity.value = event.params.value
  entity.save()
}
