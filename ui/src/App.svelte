<script lang="ts">
	import VisibilityProvider from '@providers/VisibilityProvider.svelte'
	import { TEMP_HIDE, browserMode, resName } from '@store/stores'
	import DebugBrowser from '@providers/DebugBrowser.svelte'
	import AlwaysListener from '@providers/AlwaysListener.svelte'
	import RealtorMenu from '@components/RealtorMenu.svelte'

	$resName = 'ps-realtor' // Change this to your resource name (case sensitive)
</script>

<VisibilityProvider>
	<!-- PUT STUFF HERE  -->
	<RealtorMenu />

	{#if $TEMP_HIDE}
		<div class="absolute top-1/2 left-4 h-fit bg-[color:var(--color-primary)] w-fit px-6 p-4 flex-col flex gap-4 items-center justify-center text-2xl font-bold">
			<p>Press E to confirm</p>
			<p>Press H to cancel</p>
		</div>
	{/if}
</VisibilityProvider>

<AlwaysListener />

{#if $browserMode}
	<DebugBrowser />
{/if}
