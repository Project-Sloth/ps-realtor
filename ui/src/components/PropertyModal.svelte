<script lang="ts">
	import { CONFIG, REALTOR_GRADE, SHELLS } from '@store/stores'
	import type { IProperty } from '@typings/type'
	import { SendNUI } from '@utils/SendNUI'
	import { fade } from 'svelte/transition'
	import Information from './PropertyModal/Information.svelte'
	import EditOptions from './PropertyModal/EditOptions.svelte'

	export let selectedProperty: IProperty = null

	function getImgArray() {
		let shellImgs = selectedProperty.extra_imgs
		const shell = selectedProperty.shell
		shellImgs = [...shellImgs, ...$SHELLS[shell].imgs]
		return shellImgs
	}
</script>

{#if selectedProperty !== null}
	<div
		class="absolute w-full h-full grid place-items-center bg-[rgba(0,0,0,0.5)] z-[99999999999]"
		transition:fade={{ duration: 250 }}
	>
		<div
			class="w-[60%] h-[95%] bg-[color:var(--color-secondary)] flex flex-col p-5 overflow-y-hidden scroll-style scroll-style-vertical"
		>
			<h1
				class="text-4xl px-[2rem] text-center font-bold w-full py-4 h-fit bg-[color:var(--color-tertiary)] flex flex-row items-center"
			>
			<p class="absolute w-full text-center left-0 z-10">Property Details</p>
				<button
					class="grid z-[11] place-items-center w-16 h-16 bg-[color:var(--color-secondary)] text-[color:var(--color-accent)]"
					on:click={() => (selectedProperty = null)}
				>
					<i class="fas fa-times" />
				</button>
			</h1>

			<h2 class="text-3xl text-center font-bold pt-4">
				{selectedProperty.street} {selectedProperty.property_id}
			</h2>

			<div
				class="w-full flex h-full flex-row items-start justify-between pt-[4rem] overflow-y-hidden scroll-style scroll-style-vertical"
			>
				<div
					class="flex flex-col justify-start h-full items-start w-full "
				>
					<!-- Main Content -->
					<Information {selectedProperty} />

					<!-- Realtor Job Stuff -->
					{#if $REALTOR_GRADE >= $CONFIG.manageProperty}
						<EditOptions bind:selectedProperty />
					{/if}
				</div>

				<div
					class="w-full h-[95%] pb-[5rem] flex flex-row flex-wrap gap-4 justify-center items-start max-w-[60%] overflow-y-scroll scroll-style scroll-style-vertical"
				>
					{#key selectedProperty.shell}
						{#key selectedProperty.extra_imgs}
							{#each getImgArray() as img}
								<div
									class="w-[100%] bg-[color:var(--color-tertiary)] flex flex-col gap-2 items-center justify-center p-2"
								>
									<img
										class="w-[100%] object-cover"
										src={img.url}
										alt=""
									/>
									<p class="text-2xl">{img.label}</p>
								</div>
							{/each}
						{/key}
					{/key}
				</div>
			</div>
		</div>
	</div>
{/if}
