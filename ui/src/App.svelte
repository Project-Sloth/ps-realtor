<script lang="ts">
	import VisibilityProvider from '@providers/VisibilityProvider.svelte'
	import { browserMode, resName } from '@store/stores'
	import DebugBrowser from '@providers/DebugBrowser.svelte'
	import AlwaysListener from '@providers/AlwaysListener.svelte'
	import RealtorMenu from '@components/RealtorMenu.svelte'
	import { SendNUI } from '@utils/SendNUI'

	$resName = 'ps-realtor' // Change this to your resource name (case sensitive)

	SendNUI('uiLoaded')
</script>

<VisibilityProvider>
	<RealtorMenu />
</VisibilityProvider>

<AlwaysListener />

{#if $browserMode}
	<DebugBrowser />
{/if}
